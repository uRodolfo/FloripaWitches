extends ContactDamageComponent
class_name BossContactDamageComponent


@export var boss_damage: float = 1.0
@export var boss_damage_interval: float = 1.0


func _ready() -> void:
	damage = boss_damage
	damage_interval = boss_damage_interval

	target_group = &"Player"
	active_on_ready = true

	super._ready()

	# Garante que a Area2D esteja detectando
	contact_area.monitoring = true

	# Garante que o componente esteja ativo
	activate()


func _physics_process(_delta: float) -> void:
	if not damage_enabled:
		return

	var overlapping_bodies := (
		contact_area.get_overlapping_bodies()
	)

	# ====================================
	# ADICIONA QUEM ESTÁ ENCOSTANDO
	# ====================================

	for body in overlapping_bodies:
		if not body is Node2D:
			continue

		var target := body as Node2D

		if not _can_damage_target(target):
			continue

		if not targets.has(target):
			targets.append(target)

			# Dano imediato ao encostar
			_apply_damage(target)

	# ====================================
	# REMOVE QUEM NÃO ESTÁ MAIS ENCOSTANDO
	# ====================================

	for target in targets.duplicate():
		if not is_instance_valid(target):
			targets.erase(target)
			continue

		if not overlapping_bodies.has(target):
			targets.erase(target)

	# ====================================
	# CONTROLA O TIMER
	# ====================================

	if targets.is_empty():
		timer.stop()

	elif timer.is_stopped():
		timer.start()


func _apply_damage(target: Node2D) -> void:
	if not is_instance_valid(target):
		return

	if not target.is_in_group("Player"):
		return

	for child in target.get_children():
		if child is PlayerHealthComponent:
			var player_health := (
				child as PlayerHealthComponent
			)

			player_health.damage(
				boss_damage
			)

			return
