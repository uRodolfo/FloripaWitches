extends Control

@onready var menu_button: TextureButton = $MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	pass # Replace with function body.
