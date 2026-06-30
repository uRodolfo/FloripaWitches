extends Node2D
class_name ContactDamageComponent

@export var damage: float = 1.0
@export var damage_interval: float = 1.0
@export var target_group: String = "Player"
@export var health_component_name: String = "PlayerHealthComponent"

var targets: Array[Node2D] = []

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = damage_interval
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)


func start_damage(target: Node2D) -> void:
	if not target.is_in_group(target_group):
		return

	if not targets.has(target):
		targets.append(target)

	if timer.is_stopped():
		timer.start()


func stop_damage(target: Node2D) -> void:
	if targets.has(target):
		targets.erase(target)

	if targets.is_empty():
		timer.stop()


func _on_timer_timeout() -> void:
	for target in targets.duplicate():
		if not is_instance_valid(target):
			targets.erase(target)
			continue

		var health_component = target.get_node_or_null(health_component_name)

		if health_component == null:
			continue

		if health_component.has_method("take_damage"):
			health_component.take_damage(damage)
		elif health_component.has_method("damage"):
			health_component.damage(damage)
		elif health_component.has_method("_damage"):
			health_component._damage(damage)

	if targets.is_empty():
		timer.stop()
