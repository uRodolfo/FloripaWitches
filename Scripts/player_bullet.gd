extends Area2D

signal collided()

var direction := Vector2.ZERO
var speed : float

func _ready() -> void:
	#body_entered.connect(_on_body_entered)
	pass
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer or body.is_in_group("Enemy"):
		collided.emit()
		queue_free()
