extends State


@onready var summoning_state: BossSummoningState = (
	$"../Summoning"
)

var last_attack: String = ""


func enter() -> void:
	call_deferred("choose_attack")


func choose_attack() -> void:
	var attacks: Array[String] = [
		"shooting",
		"dash"
	]

	# Só pode escolher Summoning se estiver fora do cooldown
	if summoning_state.can_summon:
		attacks.append("summoning")

	# Evita repetir o mesmo ataque consecutivamente
	if attacks.size() > 1:
		attacks.erase(last_attack)

	var selected_attack: String = attacks.pick_random()

	last_attack = selected_attack

	transition_to(selected_attack)
