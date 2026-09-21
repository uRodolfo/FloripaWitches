class_name Enemy
extends CharacterBody2D

signal was_damaged_by(source: Node2D)

var target: Node2D = null
var player: Node2D = null

@export var stats: EnemyStats

@onready var nav_map_rid : RID = get_world_2d().navigation_map
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var navigation_update_interval: Timer = $NavigationAgent2D/NavigationUpdateInterval

@onready var health: EnemyHealthComponent = (
	$EnemyHealthComponent
)

@onready var sprite: Sprite2D = (
	$Sprite2D
)

@onready var contact_damage: ContactDamageComponent = (
	$ContactDamageComponent
)


func _ready() -> void:
	if stats == null:
		push_error(
			"EnemyStats não foi definido."
		)

		return

	player = get_tree().get_first_node_in_group(
		"Player"
	) as Node2D

	if not player:
		push_error(
			"Player não encontrado."
		)

	health.start(
		stats.max_health
	)

	health.died.connect(
		_on_died
	)

	health.damaged_by.connect(
		_on_damaged_by
	)

	if stats.sprite_texture:
		sprite.texture = stats.sprite_texture


func _physics_process(
	delta: float
) -> void:
	if is_instance_valid(target):
		follow_player(delta)
	else:
		target = null
		#velocity = Vector2.ZERO

	move_and_slide()


func follow_player(
	_delta: float
) -> void:
	if not is_instance_valid(target):
		target = null

		return

	pathfind_and_move_to(target.global_position)

var nav_target_position : Vector2
func pathfind_and_move_to(to: Vector2) -> void:
	nav_target_position = to
	var nav_next_position = navigation_agent_2d.get_next_path_position()
	
	if navigation_agent_2d.is_target_reached():
		velocity = Vector2.ZERO
		return
	
	var direction: Vector2 = (
		nav_next_position
		- global_position
	).normalized()

	velocity = (
		direction
		* stats.speed
	)

func _on_navigation_update_interval_timeout() -> void:
	if not nav_target_position:
		return
	
	navigation_agent_2d.target_position = nav_target_position

func _on_damaged_by(
	_damage_amount: float,
	source: Node2D
) -> void:
	if not is_instance_valid(source):
		return

	if not (source.is_in_group("Mofas") or source.is_in_group("PlayerBullet")):
		return

	was_damaged_by.emit(source)
	#aggro_player()


func aggro_player() -> void:
	if not is_instance_valid(player):
		return

	target = player


func _on_hurtbox_area_entered(
	area: Area2D
) -> void:
	if area.is_in_group(
		"PlayerBullet"
	):
		health.damage_from(1, area)

		#aggro_player()

func _on_died() -> void:
	score.add_points(10)

	queue_free()


#func _on_sight_area_body_entered(
	#body: Node2D
#) -> void:
	#if body.is_in_group(
		#"Player"
	#):
		#target = body


func _on_contact_area_body_entered(
	body: Node2D
) -> void:
	contact_damage.start_damage(
		body
	)


func _on_contact_area_body_exited(
	body: Node2D
) -> void:
	contact_damage.stop_damage(
		body
	)


func _on_i_frames_blink_interval_timeout() -> void:
	pass
