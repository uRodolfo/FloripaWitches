extends CharacterBody2D

const SPEED = 40

var target = null

func _physics_process(delta: float) -> void:
	if target:
		_attack()
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _attack() -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * SPEED


func _on_sight_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
