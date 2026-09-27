extends State
class_name BossDashState


@export var boss: Boss

@export var lunge_speed: float = 400.0

@export var telegraph_time: Timer
@export var attacking_interval: Timer
@export var lunge_lock_timer: Timer


var _direction_to_player: Vector2 = Vector2.ZERO

var _is_attacking: bool = false
var _can_stop: bool = true


func physics_update(_delta: float) -> void:
	if _is_attacking:
		boss.velocity = (
			_direction_to_player
			* lunge_speed
		)

		if boss.get_last_slide_collision() and _can_stop:
			stop_attacking()


func enter() -> void:
	if not attacking_interval.timeout.is_connected(
		stop_attacking
	):
		attacking_interval.timeout.connect(
			stop_attacking
		)

	if not lunge_lock_timer.timeout.is_connected(
		_on_lunge_lock_timeout
	):
		lunge_lock_timer.timeout.connect(
			_on_lunge_lock_timeout
		)

	if not telegraph_time.timeout.is_connected(
		start_attacking
	):
		telegraph_time.timeout.connect(
			start_attacking
		)

	boss.velocity = Vector2.ZERO

	_is_attacking = false
	_can_stop = false

	telegraph_time.start()


func start_attacking() -> void:
	if not is_instance_valid(boss.player):
		transition_to("combat")
		return

	_direction_to_player = (
		boss.global_position.direction_to(
			boss.player.global_position
		)
	)

	_is_attacking = true
	_can_stop = false

	attacking_interval.start()
	lunge_lock_timer.start()


func _on_lunge_lock_timeout() -> void:
	_can_stop = true


func stop_attacking() -> void:
	if not _is_attacking:
		return

	_is_attacking = false

	boss.velocity = Vector2.ZERO

	transition_to("combat")


func exit() -> void:
	telegraph_time.stop()
	attacking_interval.stop()
	lunge_lock_timer.stop()

	_is_attacking = false
	_can_stop = false

	boss.velocity = Vector2.ZERO
