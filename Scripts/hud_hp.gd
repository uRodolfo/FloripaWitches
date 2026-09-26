extends AnimatedSprite2D

var health_component: HealthComponent

@export var shaking_component : ShakingComponent
@export var petal_particles : Array[CPUParticles2D]

func _ready() -> void:
	if shaking_component:
		GlobalEvents.player_hit.connect(shaking_component.apply_shake)
		GlobalEvents.player_hit.connect(_drop_petal)
	
	var player := get_tree().get_first_node_in_group(
		"Player"
	)

	if not player:
		push_error("PLAYER NÃO ENCONTRADO")
		return

	health_component = player.get_node(
		"PlayerHealthComponent"
	) as HealthComponent
	
	play("Alive")
	pause()


func _process(_delta: float) -> void:
	if not health_component:
		return

	if health_component.health > 0:
		frame = int(health_component.health) - 1


func _on_player_died() -> void:
	play("Death")

func _drop_petal() -> void:
	var index : int = int(health_component.max_health - health_component.health - 1)
	index = mini(index, petal_particles.size() - 1)
	
	petal_particles[index].emitting = true
