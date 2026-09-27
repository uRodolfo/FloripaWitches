extends ShootingComponent
class_name BossShootingComponent


@export var triple_shot: bool = true
@export var triple_delay: float = 0

func shoot(target_position: Vector2) -> void:
	if not canshoot:
		return

	var direction: Vector2 = (
		target_position
		- spawnpos.global_position
	).normalized()

	if triple_shot:
		shoot_boss_triple(direction)
	else:
		shoot_single(direction)

	canshoot = false
	shootspeed.start()


func shoot_boss_triple(direction: Vector2) -> void:
	create_bullet(
		bullet_scene,
		direction
	)


func _on_shotspeed_timeout() -> void:
	canshoot = true
