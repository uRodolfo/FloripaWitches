extends Node

signal player_hit

func change_scene_to_thank_you():
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/thank_you.tscn")
