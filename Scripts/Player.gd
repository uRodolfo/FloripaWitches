extends CharacterBody2D
class_name Player

#Player Attributes
var speed = 300                  #Velocidade atual do jogador
@export var baseSpeed = 80      #Velocidade Base do jogador
var direction = Vector2.ZERO


#Nodes
@onready var _player_shooting := $ShootingComponent #Lógica de tiros do jogador
#@onready var _shoot_key_interval := $ShootKeyInterval #Tempo para segurar o botão para alternar o modo de tiro
#@onready var health_component := $HealthComponent #Componente que faz a lógica de vida

func _ready() -> void:
	
	pass
	
func _physics_process(delta):
	velocity = direction.normalized() * speed
	move_and_slide()

func _process(delta):
	# Movimentação
	handle_movement()
	handle_shooting()
	
func _on_shoot_key_interval_timeout() -> void:
	##Tiros do jogador
	if Input.is_action_pressed("Shoot"):
		_player_shooting.is_shooting = !_player_shooting.is_shooting

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


func _on_shootspeed_timeout() -> void:
	_player_shooting.canshoot = true
	pass # Replace with function body.
