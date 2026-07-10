extends Label

func _ready():
	score.points = 0

func _process(delta):
	text = str(score.points)
