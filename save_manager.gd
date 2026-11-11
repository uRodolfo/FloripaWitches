extends Node

const SAVE_PATH = "user://scores.save"

var current_scores: Array = [] 

func _ready():
	load_scores()

func load_scores():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		var result = json.parse(content)
		if result == OK:
			current_scores = json.data
			print("Scores carregados: ", current_scores)
		else:
			current_scores = []
			print("Nenhum save encontrado")
		file.close()
	else:
		current_scores = []

func save_scores():
	var json_string = JSON.stringify(current_scores)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

func add_or_update_score(player_name: String, new_score: float):
	var found = false
	for i in range(current_scores.size()):
		if current_scores[i]["name"] == player_name:
			found = true
			if new_score > current_scores[i]["score"]:
				current_scores[i]["score"] = new_score
			break
	if not found:
		current_scores.append({"name": player_name, "score": new_score})
	save_scores()

func get_high_score_for_name(player_name: String) -> float:
	for entry in current_scores:
		if entry["name"] == player_name:
			return entry["score"]
	return 0.0

func get_all_scores() -> Array:
	return current_scores
