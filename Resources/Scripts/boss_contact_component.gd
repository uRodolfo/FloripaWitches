extends ContactDamageComponent
class_name BossContactDamageComponent


@export var boss_damage: float = 2.0
@export var boss_damage_interval: float = 1.0


func _ready() -> void:
	damage = boss_damage
	damage_interval = boss_damage_interval

	target_group = &"Player"
	active_on_ready = true

	super._ready()


func _apply_damage(target: Node2D) -> void:
	if not is_instance_valid(target):
		return

	if not target.is_in_group("Player"):
		return

	var player_health: Node = null

	# Procura automaticamente um componente de vida no Player
	for child in target.get_children():
		if (
			child.has_method("damage_from")
			or child.has_method("_damage")
			or child.has_method("take_damage")
			or child.has_method("damage")
		):
			player_health = child
			break

	if player_health == null:
		push_error("Boss não encontrou o HealthComponent do Player.")
		return

	if player_health.has_method("damage_from"):
		player_health.call(
			"damage_from",
			boss_damage,
			damage_source
		)
		return

	if player_health.has_method("_damage"):
		player_health.call(
			"_damage",
			boss_damage
		)
		return

	if player_health.has_method("take_damage"):
		player_health.call(
			"take_damage",
			boss_damage
		)
		return

	if player_health.has_method("damage"):
		player_health.call(
			"damage",
			boss_damage
		)
		
func _on_body_entered(body: Node2D) -> void:
	print("BOSS DETECTOU: ", body.name)

	super._on_body_entered(body)
