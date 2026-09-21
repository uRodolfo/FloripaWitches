extends State

@export var enemy : Enemy
@export var navigation_update_interval: Timer
@export var sight_area : Area2D

## Square shaped range from initial spawn point for a random point in space to be selected
@export var roaming_range : float = 40.0
## Maximum time that the entity can be without updating its roaming target
@export var idle_time_max : float = 4.0
## Minimum time that the entity can be without updating its roaming target
@export var idle_time_min : float = 1.0

@onready var spawn_position : Vector2 = enemy.global_position

var time_left : float = 0.0
var nav_target : Vector2 = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if time_left <= 0:
		update_nav_target()
		return
	time_left -= _delta
	
	enemy.pathfind_and_move_to(nav_target)

func enter() -> void:
	navigation_update_interval.stop()
	enemy.target = null
	time_left = 0.1
	
	sight_area.body_entered.connect(_on_sight_area_body_entered)
	enemy.was_damaged_by.connect(_on_damaged_by)

func exit() -> void:
	sight_area.body_entered.disconnect(_on_sight_area_body_entered)
	enemy.was_damaged_by.disconnect(_on_damaged_by)

func update_nav_target() -> void:
	time_left = randf_range(idle_time_max, idle_time_min)
	var rand_x = randf_range(-roaming_range, roaming_range)
	var rand_y = randf_range(-roaming_range, roaming_range)
	var global_target = Vector2(rand_x + spawn_position.x, rand_y + spawn_position.y)
	nav_target = NavigationServer2D.map_get_closest_point(enemy.nav_map_rid, global_target)
	navigation_update_interval.timeout.emit() #Emite o timeout para que o inimigo atualize o pathfinding
	
func _on_sight_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		transition_to("chasing")

func _on_damaged_by(source: Node2D) -> void:
	transition_to("chasing")
