extends State


@export var boss: Boss
@export var navigation_update_interval: Timer

@export var roaming_range: float = 100.0
@export var idle_time_max: float = 4.0
@export var idle_time_min: float = 1.0


@onready var sight_area: Area2D = (
	boss.get_node("SightArea")
)

@onready var spawn_position: Vector2 = (
	boss.global_position
)


var time_left: float = 0.0
var nav_target: Vector2 = Vector2.ZERO


func enter() -> void:
	if boss.aggroed:
		transition_to("combat")
		return

	boss.velocity = Vector2.ZERO
	boss.target = null

	time_left = 0.1

	if not sight_area.body_entered.is_connected(
		_on_sight_area_body_entered
	):
		sight_area.body_entered.connect(
			_on_sight_area_body_entered
		)

	if not boss.was_damaged_by.is_connected(
		_on_damaged_by
	):
		boss.was_damaged_by.connect(
			_on_damaged_by
		)

	navigation_update_interval.start()


func physics_update(delta: float) -> void:
	if boss.aggroed:
		transition_to("combat")
		return

	if time_left <= 0.0:
		update_nav_target()

	time_left -= delta

	boss.pathfind_and_move_to(
		nav_target
	)


func update_nav_target() -> void:
	time_left = randf_range(
		idle_time_min,
		idle_time_max
	)

	var rand_x := randf_range(
		-roaming_range,
		roaming_range
	)

	var rand_y := randf_range(
		-roaming_range,
		roaming_range
	)

	var global_target := Vector2(
		spawn_position.x + rand_x,
		spawn_position.y + rand_y
	)

	nav_target = NavigationServer2D.map_get_closest_point(
		boss.nav_map_rid,
		global_target
	)

	boss.nav_target_position = nav_target

	navigation_update_interval.timeout.emit()


func _on_sight_area_body_entered(
	body: Node2D
) -> void:
	print("SIGHT DETECTOU: ", body.name)

	if body.is_in_group("Player"):
		start_combat()


func _on_damaged_by(
	_source: Node2D
) -> void:
	start_combat()


func start_combat() -> void:
	if boss.aggroed:
		return

	print("BOSS PEGOU AGGRO")

	boss.aggro_player()

	transition_to("combat")


func exit() -> void:
	navigation_update_interval.stop()

	boss.velocity = Vector2.ZERO

	if sight_area.body_entered.is_connected(
		_on_sight_area_body_entered
	):
		sight_area.body_entered.disconnect(
			_on_sight_area_body_entered
		)

	if boss.was_damaged_by.is_connected(
		_on_damaged_by
	):
		boss.was_damaged_by.disconnect(
			_on_damaged_by
		)
