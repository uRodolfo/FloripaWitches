class_name Boss
extends CharacterBody2D

signal was_damaged_by(source: Node2D)


# =========================
# ATRIBUTOS DO BOSS
# =========================

@export var move_speed: float = 40.0
@export var max_health: float = 20.0


# =========================
# REFERÊNCIAS
# =========================

var target: Node2D = null
var player: Node2D = null

var nav_target_position := Vector2.ZERO


@onready var navigation_agent_2d: NavigationAgent2D = (
	$NavigationAgent2D
)

@onready var navigation_update_interval: Timer = (
	$NavigationAgent2D/NavigationUpdateInterval
)

@onready var health: EnemyHealthComponent = (
	$EnemyHealthComponent
)

@onready var sprite: Sprite2D = (
	$Sprite2D
)

@onready var contact_damage: ContactDamageComponent = (
	$BossContactComponent
)

@onready var shooting_component = (
	$BossShootingComponent
)


# =========================
# READY
# =========================

func _ready() -> void:

	player = get_tree().get_first_node_in_group(
		"Player"
	) as Node2D

	if not is_instance_valid(player):
		push_error("Player não encontrado.")
		return

	health.start(max_health)

	health.died.connect(
		_on_died
	)

	health.damaged_by.connect(
		_on_damaged_by
	)

	# Boss já começa perseguindo o Player
	target = player

	# Define o primeiro destino
	nav_target_position = player.global_position

	# Espera o NavigationRegion2D ficar pronto
	await get_tree().physics_frame

	if is_instance_valid(player):
		navigation_agent_2d.target_position = (
			player.global_position
		)


# =========================
# MOVIMENTO
# =========================

func _physics_process(delta: float) -> void:

	if is_instance_valid(target):
		follow_player(delta)
	else:
		target = null
		velocity = Vector2.ZERO

	move_and_slide()

	shoot_player()


func follow_player(_delta: float) -> void:
	if not is_instance_valid(target):
		target = null
		velocity = Vector2.ZERO
		return

	pathfind_and_move_to(target.global_position)


func pathfind_and_move_to(to: Vector2) -> void:
	nav_target_position = to

	var nav_next_position: Vector2 = (
		navigation_agent_2d.get_next_path_position()
	)

	var direction: Vector2 = (
		nav_next_position
		- global_position
	).normalized()

	velocity = direction * move_speed


# =========================
# ATUALIZAÇÃO DA NAVEGAÇÃO
# =========================

func _on_navigation_update_interval_timeout() -> void:

	if not is_instance_valid(target):
		return

	nav_target_position = target.global_position

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


func _on_attack_timer_timeout() -> void:
	shoot_player()


# =========================
# DANO
# =========================

func _on_hurtbox_area_entered(area: Area2D) -> void:

	if area.is_in_group("PlayerBullet"):
		health.damage_from(
			1.0,
			area
		)

		area.queue_free()

	elif area.is_in_group("PlayerBullet2"):
		health.damage_from(0.5,area)

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

	was_damaged_by.emit(source)


# =========================
# MORTE
# =========================

func _on_died() -> void:

	score.add_points(500)

	queue_free()


# =========================
# DANO DE CONTATO
# =========================
