extends Node2D
class_name ContactDamageComponent


@export var damage: float = 1
@export var damage_interval: float = 1

@export var target_group: StringName 
@export var health_component_name: StringName  

@export var active_on_ready: bool = true


var targets: Array[Node2D] = []

var locked_target: Node2D
var damage_enabled: bool = false


@onready var timer: Timer = $Timer
@onready var contact_area: Area2D = $ContactArea


func _ready() -> void:
	timer.wait_time = damage_interval
	timer.one_shot = false

	timer.timeout.connect(_on_timer_timeout)

	contact_area.body_entered.connect(
		_on_body_entered
	)

	contact_area.body_exited.connect(
		_on_body_exited
	)

	if active_on_ready:
		activate()
	else:
		deactivate()


func activate(
	target: Node2D = null
) -> void:
	damage_enabled = true
	locked_target = target

	_refresh_targets()


func deactivate() -> void:
	damage_enabled = false
	locked_target = null

	targets.clear()

	timer.stop()


func set_locked_target(
	target: Node2D
) -> void:
	locked_target = target

	_refresh_targets()


func clear_locked_target() -> void:
	locked_target = null

	_refresh_targets()


func start_damage(
	target: Node2D
) -> void:
	if not _can_damage_target(target):
		return

	if not targets.has(target):
		targets.append(target)

	if timer.is_stopped():
		timer.start()


func stop_damage(
	target: Node2D
) -> void:
	if targets.has(target):
		targets.erase(target)

	if targets.is_empty():
		timer.stop()


func _can_damage_target(
	target: Node2D
) -> bool:
	if not damage_enabled:
		return false

	if not is_instance_valid(target):
		return false

	if locked_target != null:
		if target != locked_target:
			return false

	if target_group != &"":
		if not target.is_in_group(target_group):
			return false

	return true


func _refresh_targets() -> void:
	targets.clear()

	timer.stop()

	if not damage_enabled:
		return

	for body in contact_area.get_overlapping_bodies():
		if body is Node2D:
			start_damage(body as Node2D)


func _on_body_entered(
	body: Node2D
) -> void:
	start_damage(body)


func _on_body_exited(
	body: Node2D
) -> void:
	stop_damage(body)


func _on_timer_timeout() -> void:
	for target in targets.duplicate():
		if not _can_damage_target(target):
			targets.erase(target)
			continue
		var health_component: Node = (
			target.get_node_or_null(
				NodePath(
					String(health_component_name)
				)
			)
		)
		if health_component == null:
			continue
		if health_component.has_method("_damage"):
			health_component.call("_damage", damage)
		elif health_component.has_method("take_damage"):
			health_component.call("take_damage", damage)
		elif health_component.has_method("damage"):
			health_component.call("damage", damage)
	if targets.is_empty():
		timer.stop()
