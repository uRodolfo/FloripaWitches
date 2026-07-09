extends Node2D
class_name ShootingComponent

var canshoot := true

@export var bullet_scene: PackedScene
@export var bullet_speed: float 

@onready var spawnpos: Marker2D = $Spawnpos
@onready var shootspeed: Timer = $Shootspeed

func shoot(target_position: Vector2) -> void:
	if canshoot:

		var bullet = bullet_scene.instantiate()
		var direction = (target_position - spawnpos.global_position).normalized()
		
		
		bullet.global_position = spawnpos.global_position
		bullet.direction = direction
		bullet.speed = bullet_speed

		get_tree().current_scene.add_child(bullet)
		bullet.global_rotation = direction.angle() + deg_to_rad(90)
		
		canshoot = false
		shootspeed.start()
