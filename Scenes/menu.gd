extends Control

@onready var play_button: TextureButton = $CanvasLayer/VBoxContainer/PlayButton

func _ready() -> void:
	play_button.grab_focus()

func _on_começar_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/comandos.tscn")

	
func _on_creditos_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/creditos.tscn")
	pass # Replace with function body.

func _on_sair_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
