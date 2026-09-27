extends State


@export var boss: Boss

@export var navigation_update_interval: Timer
@export var shooting_duration: Timer


func enter() -> void:
	if not is_instance_valid(boss.player):
		transition_to("combat")
		return

	boss.target = boss.player

	shooting_duration.wait_time = 5.0
	shooting_duration.one_shot = true

	if not shooting_duration.timeout.is_connected(
		finish_shooting
	):
		shooting_duration.timeout.connect(
			finish_shooting
		)

	navigation_update_interval.start()

	shooting_duration.start()


func physics_update(_delta: float) -> void:
	if not is_instance_valid(boss.player):
		return

	# Segue o Player
	boss.pathfind_and_move_to(
		boss.player.global_position
	)

	# Tenta atirar.
	# O Shootspeed do componente já controla o cooldown.
	boss.shooting_component.shoot(
		boss.player.global_position
	)


func finish_shooting() -> void:
	transition_to("combat")


func exit() -> void:
	shooting_duration.stop()
	navigation_update_interval.stop()

	boss.velocity = Vector2.ZERO
