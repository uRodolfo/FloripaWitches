extends Node2D
class_name ShakingComponent

@export var shaking_object : Node2D

var shake = 5
var shake_count = 10
var shake_duration = 0.05
var damping = 0.5

var _can_shake = true
var _current_shake = shake

var pos_tween : Tween = create_tween()

func apply_shake() -> void:
	if _can_shake:
		reset_tween()
		_can_shake = false
		
		var initial_position : Vector2 = shaking_object.global_position
		for i in shake_count:
			pos_tween.tween_property(shaking_object, "global_position", Vector2(global_position.x + (_current_shake * (-1 ** i)), global_position.y), shake_duration)
			_current_shake -= damping
	
		pos_tween.tween_property(shaking_object, "global_position", initial_position, shake_duration).finished.connect(_enable_shaking, CONNECT_ONE_SHOT)
		_current_shake = shake

func _enable_shaking() -> void:
	_can_shake = true

func reset_tween() -> void:
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
