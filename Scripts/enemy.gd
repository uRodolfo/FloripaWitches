extends CharacterBody2D

const SPEED = 40
var hp = 3
var target = null
@export var damage = 1

@onready var health := $EnemyHealthComponent

func _physics_process(delta: float) -> void:
	if target:
		followPlayer(delta)
	else:
		velocity = Vector2.ZERO

	if hp <= 0:
		queue_free()

	move_and_slide()


func followPlayer(delta: float):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * SPEED



func _on_sight_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body


#func _on_hurtbox_area_body_entered(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#body.damage(2)



func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		health._damage(5)
	## Em vez do 5 aqui, seria melhor passar o dano da bala do player.
	
func _damage():
	
	pass
