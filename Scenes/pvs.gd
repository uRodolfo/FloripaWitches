extends Label


var health_component: HealthComponent


func _ready() -> void:
	var player := get_tree().get_first_node_in_group(
		"Player"
	)

	if not player:
		push_error("PLAYER NÃO ENCONTRADO")
		return

	health_component = player.get_node(
		"PlayerHealthComponent"
	) as HealthComponent


func _process(_delta: float) -> void:
	if not health_component:
		return

	text = str(
		roundi(health_component.health)
	)
