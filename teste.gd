extends Sprite2D

var shake = 5
var shake_count = 10
var shake_duration = 0.05

var _can_shake = true

func _process(delta: float) -> void:
	
	var tween : Tween = create_tween()
	
	if Input.is_action_just_pressed("ui_accept"):
		if _can_shake:
			_can_shake = false
			var initial_position : Vector2 = global_position
			for i in shake_count:
				tween.tween_property(self, "global_position", Vector2(global_position.x + shake * (-1**i), global_position.y), shake_duration)
		
			tween.tween_property(self, "global_position", initial_position, shake_duration).finished.connect(_enable_shaking, CONNECT_ONE_SHOT)

func _enable_shaking() -> void:
	_can_shake = true
