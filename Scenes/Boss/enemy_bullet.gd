extends Area2D

signal collided()

var direction := Vector2.ZERO
var speed: float

@export var split_bullet_scene: PackedScene
@export var split_speed: float = 300.0
@export var split_angle: float = 30.0
@export var damage_amount: float = 1.0
@onready var split_spawn: Marker2D = $SplitSpawn
@onready var split_timer: Timer = $SplitTimer


func _ready() -> void:
	split_timer.start()


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_split_timer_timeout() -> void:
	spawn_split_bullet(
		direction.rotated(
			deg_to_rad(-split_angle)
		)
	)

	spawn_split_bullet(
		direction.rotated(
			deg_to_rad(split_angle)
		)
	)


func spawn_split_bullet(
	new_direction: Vector2
) -> void:

	if split_bullet_scene == null:
		return

	var bullet = split_bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = split_spawn.global_position
	bullet.direction = new_direction
	bullet.speed = split_speed

	bullet.global_rotation = (
		new_direction.angle()
		+ deg_to_rad(90)
	)


func _on_body_entered(body: Node2D) -> void:

	# Parede
	if body is TileMapLayer:
		collided.emit()
		queue_free()
		return

	# Player
	if body.is_in_group("Player"):
		damage_player(body)

		collided.emit()
		queue_free()


func damage_player(player: Node2D) -> void:
	for child in player.get_children():
		if child is PlayerHealthComponent:
			var player_health := child as PlayerHealthComponent

			player_health.damage(
				damage_amount
			)

			return


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
