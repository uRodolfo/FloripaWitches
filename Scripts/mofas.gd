class_name Puppet
extends CharacterBody2D


const SPEED: float = 600.0
const JUMP_VELOCITY: float = -400.0


@onready var state_machine: StateMachine = (
	$"State Machine"
)

@onready var sprite: Sprite2D = $Sprite2D


var attack_target: Node2D


func _physics_process(_delta: float) -> void:
	update_facing_direction()


func update_facing_direction() -> void:
	if abs(velocity.x) < 0.1:
		return

	sprite.flip_h = velocity.x > 0.0


func _unhandled_input(
	event: InputEvent
) -> void:
	if not event.is_action_pressed(
		&"AttackMofas"
	):
		return

	if not has_attack_target():
		return

	cancel_attack()

	get_viewport().set_input_as_handled()


func start_attack(
	target: Node2D
) -> void:
	if has_attack_target():
		return

	if not is_instance_valid(target):
		return

	if target.is_queued_for_deletion():
		return

	attack_target = target

	print(
		"MOFAS ATACANDO: ",
		attack_target
	)

	state_machine.change_state_by_name(
		&"Attack"
	)


func cancel_attack() -> void:
	print("ATAQUE CANCELADO")

	attack_target = null

	state_machine.change_state_by_name(
		&"FollowPlayer"
	)


func finish_attack() -> void:
	cancel_attack()


func has_attack_target() -> bool:
	if not is_instance_valid(
		attack_target
	):
		return false

	if attack_target.is_queued_for_deletion():
		return false

	return true
