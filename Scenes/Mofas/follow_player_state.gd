class_name FollowPlayerState
extends State


@export var follow_distance: float = 5.0
@export var slowdown_distance: float = 150.0
@export var lerp_speed: float = 8.0


@onready var puppet: Puppet = (
	get_parent().get_parent() as Puppet
)


var player: CharacterBody2D


func enter() -> void:
	player = get_tree().get_first_node_in_group(
		"Player"
	) as CharacterBody2D

	if not player:
		push_error("PLAYER NÃO ENCONTRADO")


func physics_update(delta: float) -> void:
	if not puppet:
		return

	if not player:
		return

	var distance: float = puppet.global_position.distance_to(
		player.global_position
	)

	var direction: Vector2 = (
		puppet.global_position.direction_to(
			player.global_position
		)
	)

	var target_velocity: Vector2 = Vector2.ZERO

	if distance > follow_distance:
		var speed_multiplier: float = 1.0

		if distance < slowdown_distance:
			speed_multiplier = inverse_lerp(
				follow_distance,
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
