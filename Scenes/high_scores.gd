extends Label

func _ready():
	update_ranking()

func update_ranking():
	var scores = SaveManager.get_all_scores()
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	print("Scores no label: ", scores) 
	
	var all_text = ""
	for entry in scores:
		all_text += entry["name"] + ": " + str(entry["score"]) + "\n"
	
	text = all_text
