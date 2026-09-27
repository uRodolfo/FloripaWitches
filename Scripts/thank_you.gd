extends Control

@onready var exit_button: TextureButton = $CanvasLayer/VBoxContainer/ExitButton

func _on_sair_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	pass # Replace with function body.
