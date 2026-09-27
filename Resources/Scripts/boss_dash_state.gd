extends State
class_name BossDashState


@export var boss: Boss

@export var lunge_speed: float = 400.0

@export var telegraph_time: Timer
@export var attacking_interval: Timer
@export var lunge_lock_timer: Timer


var _direction_to_player: Vector2 = Vector2.ZERO

var _is_attacking: bool = false
var _can_stop: bool = false


func enter() -> void:
	# IMEDIATAMENTE PARA
	boss.stop_movement()

	_is_attacking = false
	_can_stop = false

	# Depois toca Dash parado
	boss.play_dash_animation()

	# Já olha para o Player
	if is_instance_valid(boss.player):
		var direction_to_player := (
			boss.global_position.direction_to(
				boss.player.global_position
			)
		)

		if abs(direction_to_player.x) > 0.1:
			boss.sprite.flip_h = (
				direction_to_player.x > 0
			)

	if not attacking_interval.timeout.is_connected(
		stop_attacking
	):
		attacking_interval.timeout.connect(
			stop_attacking
		)

	if not telegraph_time.timeout.is_connected(
		start_attacking
	):
		telegraph_time.timeout.connect(
			start_attacking
		)

	if not lunge_lock_timer.timeout.is_connected(
		_on_lunge_lock_timeout
	):
		lunge_lock_timer.timeout.connect(
			_on_lunge_lock_timeout
		)

	telegraph_time.start()
	lunge_lock_timer.start()


func physics_update(_delta: float) -> void:

	# =========================
	# PREPARANDO O DASH
	# =========================

	if not _is_attacking:
		boss.stop_movement()
		return


	# =========================
	# LUNGE
	# =========================

	boss.velocity = (
		_direction_to_player
		* lunge_speed
	)

	boss.update_facing()

	boss.move_and_slide()


	# Agora verifica colisão DEPOIS do movimento
	if (
		boss.get_slide_collision_count() > 0
		and _can_stop
	):
		stop_attacking()


func start_attacking() -> void:
	if not is_instance_valid(boss.player):
		boss.stop_movement()
		transition_to("combat")
		return

	_direction_to_player = (
		boss.global_position.direction_to(
			boss.player.global_position
		)
	)

	if abs(_direction_to_player.x) > 0.1:
		boss.sprite.flip_h = (
			_direction_to_player.x > 0
		)

	_is_attacking = true

	attacking_interval.start()


func _on_lunge_lock_timeout() -> void:
	_can_stop = true


func stop_attacking() -> void:
	if not _is_attacking:
		return

	_is_attacking = false

	boss.stop_movement()

	transition_to("combat")


func exit() -> void:
	telegraph_time.stop()
	attacking_interval.stop()
	lunge_lock_timer.stop()

	_is_attacking = false
	_can_stop = false

	boss.stop_movement()
