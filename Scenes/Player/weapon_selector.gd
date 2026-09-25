extends Control

@onready var single_box: Panel = $HBoxContainer/SingleShot
@onready var triple_box: Panel = $HBoxContainer/TripleShot
@onready var hide_timer: Timer = $HideTimer
var fade_tween: Tween

var selected_index := 0

signal weapon_changed(index: int)


func _ready() -> void:
	visible = false
	hide_timer.timeout.connect(_on_hide_timer_timeout)


func next_weapon() -> void:
	visible = true
	hide_timer.start()

	# Se os dois tiros estiverem desbloqueados
	if score.Magic and score.Magic2:
		if selected_index == 0:
			selected_index = 1
		else:
			selected_index = 0

	# Só tiro normal desbloqueado
	elif score.Magic:
		selected_index = 0

	# Só tiro triplo desbloqueado
	elif score.Magic2:
		selected_index = 1

	update_selection()
	hide_timer.wait_time = 1


func previous_weapon() -> void:
	# Como só temos 2 armas, faz a mesma coisa
	next_weapon()


func update_selection() -> void:

	# Tiro normal
	if selected_index == 0:
		single_box.modulate = Color.WHITE
		triple_box.modulate = Color(0.4, 0.4, 0.4)

	# Tiro triplo
	elif selected_index == 1:
		single_box.modulate = Color(0.4, 0.4, 0.4)
		triple_box.modulate = Color.WHITE

	weapon_changed.emit(selected_index)

func _on_hide_timer_timeout() -> void:
	fade_tween = create_tween()

	fade_tween.tween_property(self,"modulate:a",0.0,0.5)

	fade_tween.finished.connect(_on_fade_finished)
	
func _on_fade_finished() -> void:
	visible = false
	modulate.a = 1.0
