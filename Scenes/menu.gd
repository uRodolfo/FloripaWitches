extends Control

@onready var select: AudioStreamPlayer = $Select

func _ready() -> void:
	var start = $"VBoxContainer/Começar"
	start.grab_focus()
	

func _on_começar_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	

func _on_comandos_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/comandos.tscn")


func _on_creditos_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/creditos.tscn")

func _on_sair_button_down() -> void:
	get_tree().quit()
