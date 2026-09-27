extends Control

@onready var start_button: TextureButton = $StartButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.grab_focus()

func _on_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
