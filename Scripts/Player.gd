extends CharacterBody2D
class_name Player

signal died

@export var speed = 100
@export var baseSpeed = 50
@export var starting_hp: float = 15

var direction = Vector2.ZERO

@onready var shooting_component := $ShootingComponent
@onready var player_health_component: PlayerHealthComponent = $PlayerHealthComponent
@onready var weapon_selector = $WeaponSelector

func _ready() -> void:
	player_health_component.start(starting_hp)
	player_health_component.died.connect(_on_died)
	score.Magic = false

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
			shooting_component.shoot(get_global_mouse_position())

func _on_died() -> void:
	died.emit()
	queue_free()

func _on_shoot_key_interval_timeout() -> void:
	if Input.is_action_pressed("Shoot"):
		shooting_component.is_shooting = !shooting_component.is_shooting

func _on_shootspeed_timeout() -> void:
	shooting_component.canshoot = true
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:

		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_selector.previous_weapon()

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_selector.next_weapon()


func _on_weapon_selector_weapon_changed(index: int) -> void:
	if index == 0:
		shooting_component.triple_shot_selected = false

	elif index == 1:
		shooting_component.triple_shot_selected = true
