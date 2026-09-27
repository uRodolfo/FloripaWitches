class_name BossSummoningState
extends State

@export var boss: Boss

@export var summon_cast: Timer
@export var summon_cooldown: Timer

var can_summon: bool = true


func _ready() -> void:
	if not summon_cast.timeout.is_connected(
		summon_enemies
	):
		summon_cast.timeout.connect(
			summon_enemies
		)

	if not summon_cooldown.timeout.is_connected(
		reset_summon
	):
		summon_cooldown.timeout.connect(
			reset_summon
		)


func enter() -> void:
	if not can_summon:
		transition_to("combat")
		return

	boss.velocity = Vector2.ZERO

	can_summon = false

	summon_cast.start()


func physics_update(_delta: float) -> void:
	boss.velocity = Vector2.ZERO


func summon_enemies() -> void:
	boss.summon_enemies()

	summon_cooldown.start()

	transition_to("combat")


func reset_summon() -> void:
	can_summon = true


func exit() -> void:
	summon_cast.stop()

	boss.velocity = Vector2.ZERO
