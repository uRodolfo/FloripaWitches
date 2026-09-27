extends Area2D

signal collided()

var direction := Vector2.ZERO
var speed : float
var damage_amount = 1

func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	pass
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

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
			player_health.damage(damage_amount)
			return

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	pass # Replace with function body.
