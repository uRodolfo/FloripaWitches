extends Sprite2D

@export var enemy : Enemy

func _process(delta: float) -> void:
	if enemy.velocity.x > 0:
		flip_h = true
	elif  enemy.velocity.x < 0:
		flip_h = false
