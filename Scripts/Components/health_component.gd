extends Node2D
class_name HealthComponent

signal died

var max_health: float = 0
var health: float = 0

func start(value: float) -> void:
	max_health = value
	health = max_health

func damage(amount: float) -> void:
	health -= amount
	
	if health <= 0:
		died.emit()
