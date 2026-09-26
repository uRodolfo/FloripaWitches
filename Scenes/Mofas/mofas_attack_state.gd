class_name AttackState
extends State


@export var stop_distance: float = 5.0
@export var slowdown_distance: float = 100.0
@export var lerp_speed: float = 10.0

@export var damage_component: ContactDamageComponent


@onready var puppet: Puppet = (
	get_parent().get_parent() as Puppet
)


var target: Node2D


func enter() -> void:
	target = puppet.attack_target

	if not _is_target_valid():
		puppet.finish_attack()
		return

	if not damage_component:
		push_error(
			"CONTACT DAMAGE COMPONENT NÃO DEFINIDO"
		)
		return

	damage_component.activate(
		target
	)


func exit() -> void:
	if damage_component:
		damage_component.deactivate()

	target = null


func physics_update(
	delta: float
) -> void:
	if not _is_target_valid():
		puppet.finish_attack()
		return

	var distance: float = (
		puppet.global_position.distance_to(
			target.global_position
		)
	)

	var direction: Vector2 = (
		puppet.global_position.direction_to(
			target.global_position
		)
	)

	var target_velocity: Vector2 = Vector2.ZERO

	if distance > stop_distance:
		var speed_multiplier: float = 1.0

		if distance < slowdown_distance:
			speed_multiplier = inverse_lerp(
				stop_distance,
				slowdown_distance,
				distance
			)

		target_velocity = (
			direction
			* Puppet.SPEED
			* speed_multiplier
		)

	var lerp_weight: float = (
		1.0
		- exp(-lerp_speed * delta)
	)

	puppet.velocity = puppet.velocity.lerp(
		target_velocity,
		lerp_weight
	)

	puppet.move_and_slide()


func _is_target_valid() -> bool:
	if not is_instance_valid(target):
		return false

	if target.is_queued_for_deletion():
		return false

	if not target.is_inside_tree():
		return false

	return true
