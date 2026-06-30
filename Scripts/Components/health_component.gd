extends Node2D
class_name HealthComponent

@export var MAX_HEALTH : float = 10.0
var health: float

func _ready():
	start()
	

func damage(damage: float):
	health -= damage
	
	if health <= 0:
		get_parent().queue_free()

func start():
	health = MAX_HEALTH
