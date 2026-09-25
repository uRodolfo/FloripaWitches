extends State

@export var enemy : Enemy
@export var lunge_speed: float = 190.0
@export var telegraph_time: Timer       #Tempo que o inimigo fica parado antes de atacar
@export var attacking_interval: Timer   #Tempo máximo que o inimigo pode dar o dash
@export var attack_cooldown : Timer     #Tempo entre ataques

var _direction_to_player : Vector2
var _is_attacking : bool = false
var _can_bounce : bool = true
var _lunge_velocity : Vector2

var can_attack : bool = true #Usado no state que chama para saber se pode atacar


func physics_update(_delta: float) -> void:
	if _is_attacking:
		
		var collision := enemy.get_last_slide_collision()
		enemy.velocity = _lunge_velocity
		if collision and _can_bounce:
			_lunge_velocity = enemy.velocity.bounce(collision.get_normal())
			_can_bounce = false
		else:
			_can_bounce = true
		

func enter() -> void:
	attacking_interval.timeout.connect(stop_attacking)
	attack_cooldown.timeout.connect(on_attack_cooldown_timeout)
	telegraph_time.timeout.connect(on_telegraph_time_timeout)
	
	_direction_to_player = enemy.global_position.direction_to(enemy.player.global_position)
	_lunge_velocity = _direction_to_player * lunge_speed
	
	telegraph_time.start()
	attack_cooldown.start()
	enemy.velocity = Vector2.ZERO
	can_attack = false
	_can_bounce = true

func exit() -> void:
	attacking_interval.timeout.disconnect(stop_attacking)
	telegraph_time.timeout.disconnect(on_telegraph_time_timeout)
	
	_is_attacking = false

func stop_attacking() -> void:
	_is_attacking = false
	transition_to("chasing")

func on_attack_cooldown_timeout() -> void:
	can_attack = true

func on_telegraph_time_timeout() -> void:
	_is_attacking = true
	attacking_interval.start()
