extends Node2D
class_name HealthComponent

signal died
signal health_changed(current_health: float, max_health: float)

var max_health: float = 0
var health: float = 0
var dead: bool = false

func start(value: float) -> void:
	max_health = value
	health = max_health
	dead = false
	health_changed.emit(health, max_health)

func damage(amount: float) -> void:
	if dead:
		return

	health -= amount
	health = max(health, 0)

	health_changed.emit(health, max_health)

	if health <= 0:
		dead = true
		died.emit()
