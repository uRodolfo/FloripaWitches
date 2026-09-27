extends ShootingComponent
class_name BossShootingComponent

@export var triple_shot: bool = true


func shoot(target_position: Vector2) -> void:
	if not canshoot:
		return

	var direction := (
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
	# Bala principal
	create_bullet(
		bullet_scene,
		direction
	)

	# Bala de cima
	create_bullet(
		bullet_triple_scene,
		direction.rotated(deg_to_rad(-30))
	)

	# Bala de baixo
	create_bullet(
		bullet_triple_scene,
		direction.rotated(deg_to_rad(30))
	)


func _on_shootspeed_timeout() -> void:
	canshoot = true
