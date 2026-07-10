extends CharacterBody2D

var target: Node2D = null

@export var stats: EnemyStats
@onready var health: EnemyHealthComponent = $EnemyHealthComponent
@onready var sprite: Sprite2D = $Sprite2D
@onready var contact_damage: ContactDamageComponent = $ContactDamageComponent

func _ready() -> void:
	if stats == null:
		push_error("EnemyStats não foi definido.")
		return

	health.start(stats.max_health)
	health.died.connect(_on_died)
 
	if stats.sprite_texture:
		sprite.texture = stats.sprite_texture

func _physics_process(delta: float) -> void:
	if target:
		follow_player(delta)
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func follow_player(delta: float):
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * stats.speed
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		health._damage(5)
##trocar esse 5 por dano passado pelo player

func _on_died() -> void:
	score.add_points(10)
	queue_free()

func _on_sight_area_body_entered(body: Node2D) -> void:
		if body.name == "Player":
			target = body
			
func _on_contact_area_body_entered(body: Node2D) -> void:
	contact_damage.start_damage(body)

func _on_contact_area_body_exited(body: Node2D) -> void:
	contact_damage.stop_damage(body)
	


func _on_i_frames_blink_interval_timeout() -> void:
	pass # Replace with function body.
