class_name EnemySpawner
extends Node2D


@export var enemy_scene: PackedScene

@export var enemy_variants: Array[EnemyStats]

@export_range(1, 100, 1)
var spawn_amount: int = 1

@export_range(0.0, 1.0, 0.01)
var spawn_at_spawner_chance: float = 1.0

@export var random_spawn_radius: float = 100.0

@export var activate_once: bool = true


var activated: bool = false


func activate() -> void:
	if activate_once and activated:
		return

	activated = true

	spawn_wave()


func spawn_wave() -> void:
	if not enemy_scene:
		push_error(
			"ENEMY SCENE NÃO DEFINIDA"
		)
		return

	if enemy_variants.is_empty():
		push_error(
			"NENHUM ENEMY STATS DEFINIDO"
		)
		return

	for index in spawn_amount:
		spawn_enemy()


func spawn_enemy() -> void:
	var enemy := (
		enemy_scene.instantiate() as Enemy
	)

	if not enemy:
		push_error(
			"A CENA INSTANCIADA NÃO É ENEMY"
		)
		return

	var random_stats: EnemyStats = (
		enemy_variants.pick_random()
	)

	enemy.stats = random_stats

	get_tree().current_scene.add_child(
		enemy
	)

	enemy.global_position = (
		get_spawn_position()
	)


func get_spawn_position() -> Vector2:
	var should_spawn_at_spawner: bool = (
		randf()
		<= spawn_at_spawner_chance
	)

	if should_spawn_at_spawner:
		return global_position

	return get_random_spawn_position()


func get_random_spawn_position() -> Vector2:
	var random_angle: float = randf_range(
		0.0,
		TAU
	)

	var random_distance: float = (
		sqrt(randf())
		* random_spawn_radius
	)

	var offset: Vector2 = (
		Vector2.RIGHT.rotated(
			random_angle
		)
		* random_distance
	)

	return global_position + offset
