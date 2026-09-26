extends CharacterBody2D
class_name Player

signal died
signal dash_start()
signal dash_end()

@export var speed = 100
@export var baseSpeed = 100
@export var starting_hp: float = 15

var direction = Vector2.ZERO
var _can_dash : bool = true

@onready var dash_cooldown: Timer = $DashCooldown
@onready var dash_duration: Timer = $DashDuration
@onready var _player_shooting := $ShootingComponent
@onready var player_health_component: PlayerHealthComponent = $PlayerHealthComponent

func _ready() -> void:
	player_health_component.start(starting_hp)
	player_health_component.died.connect(_on_died)
	
	dash_duration.timeout.connect(func(): speed = baseSpeed ; dash_end.emit())
	dash_cooldown.timeout.connect(func(): _can_dash = true)

func damage(amount: float) -> void:
	player_health_component.damage(amount)

func _physics_process(delta):
	velocity = direction.normalized() * speed
	#print(player_health_component.health)
	#print(
		#"PLAYER REAL: ",
		#get_path(),
		#" | POS: ",
		#global_position
	#)

	move_and_slide()

func _process(delta):
	handle_movement()
	handle_shooting()
	handle_dashing()

func handle_movement():
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

func handle_shooting():
	if Input.is_action_just_pressed("Shoot"):
		if score.Magic == true:
			_player_shooting.shoot(get_global_mouse_position())

func _on_died() -> void:
	died.emit()
	queue_free()

func _on_shoot_key_interval_timeout() -> void:
	if Input.is_action_pressed("Shoot"):
		_player_shooting.is_shooting = !_player_shooting.is_shooting

func _on_shootspeed_timeout() -> void:
	_player_shooting.canshoot = true

func handle_dashing() -> void:
	if Input.is_action_just_pressed("dash"):
		if _can_dash:
			speed = 300.0
			_can_dash = false
			dash_start.emit()
			dash_duration.start()
			dash_cooldown.start()
