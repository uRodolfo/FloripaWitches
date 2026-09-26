extends Node2D

@export var animation_tree : AnimationTree
@onready var owner_entity : CharacterBody2D = get_owner()

func _process(delta: float) -> void:
	animation_tree.set("parameters/Moving/blend_position", owner_entity.velocity.normalized())



func _on_follow_player_following_player() -> void:
	animation_tree.set("parameters/conditions/is_attacking", false)
	animation_tree.set("parameters/conditions/is_moving", true)


func _on_attack_attacking() -> void:
	animation_tree.set("parameters/conditions/is_moving", false)
	animation_tree.set("parameters/conditions/is_attacking", true)


func _on_attack_moving() -> void:
	animation_tree.set("parameters/conditions/is_attacking", false)
	animation_tree.set("parameters/conditions/is_moving", true)
