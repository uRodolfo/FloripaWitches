extends Node2D


@export var float_height: float = 10.0
@export var float_speed: float = 2.0


var start_position_y: float
var time: float = 0.0

signal coletado

func _ready() -> void:
	start_position_y = position.y


func _process(delta: float) -> void:
	time += delta

	position.y = (
		start_position_y
		+ sin(time * float_speed)
		* float_height
	)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		score.Magic = true
		coletado.emit()
		queue_free()
	pass # Replace with function body.
