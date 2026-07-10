class_name EnemySpawnTrigger
extends Node2D

@onready var pentagrama: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pentagrama.play()
	pass # Replace with function body.



signal triggered


var activated: bool = false


func _on_body_entered(
	body: Node2D
) -> void:
	if activated:
		return

	if not body.is_in_group(
		"Player"
	):
		return

	activated = true

	triggered.emit()
