extends CharacterBody2D

@export var speed: float = 300.0  # pixels por segundo
var direction = Vector2.ZERO

func _physics_process(delta):
	process_movement()
	move_and_slide()
	
func process_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
