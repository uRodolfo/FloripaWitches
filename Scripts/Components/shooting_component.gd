extends Node2D
class_name ShootingComponent

var canshoot := true
var canshoot3 := true

var triple_shot_selected := false


@export var bullet_scene: PackedScene
@export var bullet_triple_scene: PackedScene

@export var bullet_speed: float

@onready var spawnpos: Marker2D = $Spawnpos
@onready var shootspeed: Timer = $Shootspeed


func shoot(target_position: Vector2) -> void:
	if not canshoot:
		return

	var direction = (target_position - spawnpos.global_position).normalized()

	if triple_shot_selected and score.Magic2:
		shoot_triple(direction)

	elif score.Magic:
		shoot_single(direction)

	canshoot = false
	shootspeed.start()


func shoot_single(direction: Vector2) -> void:
	create_bullet(bullet_scene, direction)


func shoot_triple(direction: Vector2) -> void:
	create_bullet(
		bullet_triple_scene,
		direction.rotated(deg_to_rad(-30))
	)

	create_bullet(
		bullet_triple_scene,
		direction
	)

	create_bullet(
		bullet_triple_scene,
		direction.rotated(deg_to_rad(30))
	)


func create_bullet(scene: PackedScene, direction: Vector2) -> void:
	var bullet = scene.instantiate()

	bullet.global_position = spawnpos.global_position
	bullet.direction = direction
	bullet.speed = bullet_speed

	get_tree().current_scene.add_child(bullet)

	bullet.global_rotation = direction.angle() + deg_to_rad(90)


func change_shot_mode() -> void:
	if not canshoot3:
		return

	triple_shot_selected = !triple_shot_selected

	if triple_shot_selected:
		print("Tiro triplo selecionado")
	else:
		print("Tiro único selecionado")
