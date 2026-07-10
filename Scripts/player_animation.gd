extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Direction {
	DOWN,
	UP,
	RIGHT,
	LEFT
}

var current_direction = Direction.DOWN

func _process(delta):

	var input_dir = Input.get_vector("left", "right", "up", "down")

	# Atualiza a direção SOMENTE se a direção atual não estiver mais pressionada
	match current_direction:
		Direction.DOWN:
			if !Input.is_action_pressed("down"):
				if Input.is_action_pressed("left"):
					current_direction = Direction.LEFT
				elif Input.is_action_pressed("right"):
					current_direction = Direction.RIGHT
				elif Input.is_action_pressed("up"):
					current_direction = Direction.UP

		Direction.UP:
			if !Input.is_action_pressed("up"):
				if Input.is_action_pressed("left"):
					current_direction = Direction.LEFT
				elif Input.is_action_pressed("right"):
					current_direction = Direction.RIGHT
				elif Input.is_action_pressed("down"):
					current_direction = Direction.DOWN

		Direction.RIGHT:
			if !Input.is_action_pressed("right"):
				if Input.is_action_pressed("left"):
					current_direction = Direction.LEFT
				elif Input.is_action_pressed("up"):
					current_direction = Direction.UP
				elif Input.is_action_pressed("down"):
					current_direction = Direction.DOWN

		Direction.LEFT:
			if !Input.is_action_pressed("left"):
				if Input.is_action_pressed("right"):
					current_direction = Direction.RIGHT
				elif Input.is_action_pressed("up"):
					current_direction = Direction.UP
				elif Input.is_action_pressed("down"):
					current_direction = Direction.DOWN

	update_animation(input_dir)
	
func update_animation(input_dir: Vector2):

	if input_dir == Vector2.ZERO:
		sprite.stop()
		sprite.frame = 0
		return

	match current_direction:

		Direction.DOWN:
			sprite.flip_h = false
			sprite.play("Down")

		Direction.UP:
			sprite.flip_h = false
			sprite.play("Up")

		Direction.RIGHT:
			sprite.flip_h = false
			sprite.play("Run")

		Direction.LEFT:
			sprite.flip_h = true
			sprite.play("Run")
