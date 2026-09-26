extends State

@export var enemy : Enemy
@export var lunge_speed: float = 100.0
@export var telegraph_time: Timer       #Tempo que o inimigo fica parado antes de atacar
@export var attacking_interval: Timer   #Tempo máximo que o inimigo pode dar o dash
@export var attack_cooldown : Timer     #Tempo entre ataques
@export var lunge_lock_timer : Timer    #Tempo que o inimigo não pode ser parado por bater em algo

var _direction_to_player : Vector2
var _is_attacking : bool = false
var _can_stop : bool = true

var can_attack : bool = true #Usado no state que chama para saber se pode atacar


func physics_update(_delta: float) -> void:
	if _is_attacking:
		enemy.velocity = _direction_to_player * lunge_speed
		if enemy.get_last_slide_collision() and _can_stop:
			stop_attacking()

func enter() -> void:
	attacking_interval.timeout.connect(stop_attacking)
	attack_cooldown.timeout.connect(func(): can_attack = true)
	lunge_lock_timer.timeout.connect(func(): _can_stop = true)
	telegraph_time.timeout.connect(start_attacking)
	
	telegraph_time.start()
	attack_cooldown.start()
	lunge_lock_timer.start()
	enemy.velocity = Vector2.ZERO
	can_attack = false
	_can_stop = false

func exit() -> void:
	_is_attacking = false

func stop_attacking() -> void:
	_is_attacking = false
	transition_to("chasing")

func start_attacking() -> void:
		_is_attacking = true
		attacking_interval.start()
		_direction_to_player = enemy.global_position.direction_to(enemy.player.global_position)
