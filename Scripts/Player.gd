extends CharacterBody2D
class_name Player

var speed = 300
@export var baseSpeed = 80
@export var starting_hp: float = 15

var direction = Vector2.ZERO

@onready var _player_shooting := $ShootingComponent
@onready var player_health_component: PlayerHealthComponent = $PlayerHealthComponent

func _ready() -> void:
	player_health_component.start(starting_hp)
	player_health_component.died.connect(_on_died)

func damage(amount: float) -> void:
	player_health_component.damage(amount)

func _physics_process(delta):
	velocity = direction.normalized() * speed
	print(player_health_component.health)
	move_and_slide()

func _process(delta):
	handle_movement()
	handle_shooting()

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
		_player_shooting.shoot(get_global_mouse_position())

func _on_died() -> void:
	queue_free()

func _on_shoot_key_interval_timeout() -> void:
	if Input.is_action_pressed("Shoot"):
		_player_shooting.is_shooting = !_player_shooting.is_shooting

func _on_shootspeed_timeout() -> void:
	_player_shooting.canshoot = true
