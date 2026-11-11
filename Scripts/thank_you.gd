extends Control

@onready var exit_button: TextureButton = $CanvasLayer/VBoxContainer/ExitButton
@onready var type: LineEdit = $CanvasLayer/VBoxContainer/Type
@onready var score_points: Label = $CanvasLayer/ScorePoints

var current_score: int = 0

func _ready():
	current_score = score.points
	score_points.text = str(current_score)
	call_deferred("set_foco")

func set_foco():
	type.grab_focus()


func _on_sair_button_up() -> void:
	var player_name = type.text.strip_edges()
	if player_name == "":
		player_name = "Explorador(a) Anônimo(a)"
	print("Salvando: ", player_name, " - ", current_score)
	SaveManager.add_or_update_score(player_name, current_score)
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
