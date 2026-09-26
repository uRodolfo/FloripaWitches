extends Camera2D

@export var player : Player

var desired_offset: Vector2
var min_offset = -25
var max_offset = 25

func _process(delta: float) -> void:
	desired_offset = (get_global_mouse_position() - global_position) * 0.075
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset/2.0, max_offset/2.0)
	
	position = desired_offset
