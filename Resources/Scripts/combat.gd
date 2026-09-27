extends State

@export var boss: Boss

@onready var summoning_state: BossSummoningState = $"../Summoning"

var last_attack: String = ""


func enter() -> void:
	# Sempre para ao trocar de ataque
	boss.velocity = Vector2.ZERO

	call_deferred("choose_attack")


func choose_attack() -> void:
	var attacks: Array[String] = [
		"shooting",
		"dash"
	]

	if summoning_state.can_summon:
		attacks.append("summoning")

	if attacks.size() > 1:
		attacks.erase(last_attack)

	var selected_attack: String = attacks.pick_random()

	last_attack = selected_attack

	transition_to(selected_attack)


func exit() -> void:
	boss.velocity = Vector2.ZERO
