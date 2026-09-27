class_name Boss
extends CharacterBody2D

signal died
signal was_damaged_by(source: Node2D)


# =========================
# ATRIBUTOS DO BOSS
# =========================

@export var move_speed: float = 40.0
@export var max_health: float = 20.0
@export var summon_enemy_scene_1: PackedScene
@export var summon_enemy_scene_2: PackedScene
@export var summon_amount: int = 3

@onready var summon_area: Area2D = $SummonArea
@onready var summon_shape: CollisionShape2D = (
	$SummonArea/CollisionShape2D
)
# =========================
# ESTADO GERAL
# =========================

var target: Node2D = null
var player: Node2D = null

# Quando virar true, nunca mais deve voltar ao Roaming
var aggroed: bool = false

var nav_target_position: Vector2 = Vector2.ZERO


# =========================
# NAVEGAÇÃO
# =========================

@onready var nav_map_rid: RID = (
	get_world_2d().navigation_map
)

@onready var navigation_agent_2d: NavigationAgent2D = (
	$NavigationAgent2D
)

@onready var navigation_update_interval: Timer = (
	$NavigationAgent2D/NavigationUpdateInterval
)



# =========================
# COMPONENTES
# =========================

@onready var health: EnemyHealthComponent = (
	$EnemyHealthComponent
)

@onready var contact_damage: ContactDamageComponent = (
	$BossContactComponent
)

@onready var shooting_component = (
	$BossShootingComponent
)

@onready var sprite: AnimatedSprite2D = (
	$Sprite2D
)

# =========================
# READY
# =========================

func _ready() -> void:
	died.connect(GlobalEvents.change_scene_to_thank_you)
	
	player = get_tree().get_first_node_in_group(
		"Player"
	) as Node2D

	if not is_instance_valid(player):
		push_error("Player não encontrado.")
		return

	health.start(max_health)

	health.died.connect(_on_died)
	health.damaged_by.connect(_on_damaged_by)

	contact_damage.activate()

	# Quando uma animação terminar

	target = null
	aggroed = false

	# Começa em Run
	play_run_animation()

	# =========================
	# DANO DE CONTATO SEMPRE ATIVO
	# =========================

	contact_damage.activate()

	target = null
	aggroed = false

func play_run_animation() -> void:
	if sprite.animation != &"Run":
		sprite.play(&"Run")


func play_dash_animation() -> void:
	if sprite.animation != &"Dash":
		sprite.play(&"Dash")

# =========================
# PHYSICS
# =========================

func stop_movement() -> void:
	velocity = Vector2.ZERO


func update_facing() -> void:
	if abs(velocity.x) > 0.1:
		sprite.flip_h = velocity.x > 0



# =========================
# AGGRO
# =========================

func aggro_player() -> void:
	if not is_instance_valid(player):
		return

	aggroed = true
	target = player


# =========================
# NAVEGAÇÃO
# =========================

func pathfind_and_move_to(
	to: Vector2
) -> void:
	nav_target_position = to

	var nav_next_position: Vector2 = (
		navigation_agent_2d.get_next_path_position()
	)

	var direction: Vector2 = (
		nav_next_position
		- global_position
	).normalized()

	velocity = (
		direction
		* move_speed
	)


func _on_navigation_update_interval_timeout() -> void:
	if nav_target_position == Vector2.ZERO:
		return

	navigation_agent_2d.target_position = (
		nav_target_position
	)


# =========================
# TIRO
# =========================

func shoot_player() -> void:
	if not is_instance_valid(player):
		return

	if shooting_component == null:
		return

	shooting_component.shoot(
		player.global_position
	)


# Mantive para não quebrar caso você já tenha
# algum sinal conectado com esse nome.
func _on_attack_timer_timeout() -> void:
	shoot_player()


# =========================
# DANO RECEBIDO
# =========================

func _on_hurtbox_area_entered(
	area: Area2D
) -> void:

	if area.is_in_group("PlayerBullet"):
		health.damage_from(
			1.0,
			area
		)

		area.queue_free()

	elif area.is_in_group("PlayerBullet2"):
		health.damage_from(
			0.75,
			area
		)

		area.queue_free()


func _on_damaged_by(
	_damage_amount: float,
	source: Node2D
) -> void:

	if not is_instance_valid(source):
		return

	if not (
		source.is_in_group("Mofas")
		or source.is_in_group("PlayerBullet")
		or source.is_in_group("PlayerBullet2")
	):
		return

	was_damaged_by.emit(
		source
	)


# =========================
# SUMMON
# =========================

func summon_enemies() -> void:
	if summon_enemy_scene_1 == null:
		push_error("Summon Enemy Scene 1 não foi definida.")
		return

	if summon_enemy_scene_2 == null:
		push_error("Summon Enemy Scene 2 não foi definida.")
		return

	var rectangle := summon_shape.shape as RectangleShape2D

	if rectangle == null:
		push_error("SummonArea precisa usar RectangleShape2D.")
		return

	var half_size := rectangle.size / 2.0

	for i in summon_amount:
		var random_offset := Vector2(
			randf_range(-half_size.x, half_size.x),
			randf_range(-half_size.y, half_size.y)
		)

		var random_position := (
			summon_area.global_position
			+ random_offset
		)

		var valid_position := (
			NavigationServer2D.map_get_closest_point(
				nav_map_rid,
				random_position
			)
		)

		# =========================
		# SORTEIA ENTRE AS 2 CENAS
		# =========================

		var possible_enemies: Array[PackedScene] = [
			summon_enemy_scene_1,
			summon_enemy_scene_2
		]

		var selected_scene: PackedScene = (
			possible_enemies.pick_random()
		)

		var enemy = (
			selected_scene.instantiate()
		)

		# =========================
		# SPAWN
		# =========================

		get_tree().current_scene.add_child(
			enemy
		)

		enemy.global_position = (
			valid_position
		)


# =========================
# MORTE
# =========================

func _on_died() -> void:
	score.add_points(
		500
	)
	
	died.emit()
	queue_free()


# =========================
# DANO DE CONTATO
# =========================

# Mantidos porque você pode já ter sinais
# conectados a essas funções.

func _on_contact_area_body_entered(
	body: Node2D
) -> void:
	if contact_damage == null:
		return

	contact_damage.start_damage(
		body
	)


func _on_contact_area_body_exited(
	body: Node2D
) -> void:
	if contact_damage == null:
		return

	contact_damage.stop_damage(
		body
	)
