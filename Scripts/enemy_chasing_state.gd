extends State

@export var enemy : Enemy
@export var navigation_update_interval: Timer

func physics_update(_delta: float) -> void:
	if not is_instance_valid(enemy.player):
		return
	enemy.pathfind_and_move_to(enemy.player.global_position)

func enter() -> void:
	navigation_update_interval.start()
	navigation_update_interval.timeout.emit()
