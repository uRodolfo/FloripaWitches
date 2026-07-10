extends Label

@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if score.Magic == true:
		if Input.is_action_pressed("Shoot"):
			visible = false

func _on_pergaminho_coletado() -> void:
	visible = true
	timer.start()

func _on_timer_timeout() -> void:
	visible = false
