extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var start = $menu
	start.grab_focus()


func _on_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
	pass # Replace with function body.
