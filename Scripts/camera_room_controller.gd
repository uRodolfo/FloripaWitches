extends Node2D


@onready var screen_size: Vector2 = get_viewport_rect().size
@export var player_node = CharacterBody2D
@export var camera_node = Camera2D

var default_zoom : Vector2
var locked : bool = false
var pos_tween : Tween
var zoom_tween : Tween
var zoom_duration : float = 0.5
var pos_lerp_duration : float = 0.5

func _ready():
	set_screen_position()
	await get_tree().process_frame
	camera_node.position_smoothing_enabled = true
	camera_node.position_smoothing_speed = 7.0
	
	default_zoom = camera_node.zoom

func _process(delta: float) -> void:
	set_screen_position()

func set_screen_position():
	if not player_node == null:
		if not locked:
			var player_pos = player_node.global_position
			# Snapping de camera entre salas
			# Divide-se a posição do player pela sala e arredonda-se para baixo para se obter a distância do player da origem
			# medida em número de câmera (por exemplo, o jogador está a 4 câmeras da origem). Então, multiplica-se
			# o valor pelo tamanho da câmera para obter a distância em metros, adicionando metade do tamanho da câmera no
			# final para que a câmera fique centrada na sala.
			var x = floor(player_pos.x / screen_size.x) * screen_size.x + screen_size.x / 2
			var y = floor(player_pos.y / screen_size.y) * screen_size.y + screen_size.y / 2
			global_position = Vector2(x, y)

func lock_camera():
	locked = true

func unlock_camera():
	locked = false

func set_zoom(zoom: Vector2):
	interpolate_zoom(zoom)

func reset_zoom() -> void:
	interpolate_zoom(default_zoom)

func change_global_position(new_position: Vector2) -> void:
	interpolate_pos(new_position)

func interpolate_pos(final_value: Vector2):
	reset_pos_tween()
	pos_tween.set_trans(Tween.TRANS_QUAD)
	pos_tween.tween_property(self, "global_position", final_value, pos_lerp_duration)

func interpolate_zoom(final_value: Vector2):
	reset_zoom_tween()
	zoom_tween.set_trans(Tween.TRANS_CUBIC)
	zoom_tween.tween_property(camera_node, "zoom", final_value, zoom_duration)
	
func reset_zoom_tween() -> void:
	if zoom_tween:
		zoom_tween.kill()
	zoom_tween = create_tween()
	

func reset_pos_tween() -> void:
	if pos_tween:
		pos_tween.kill()
	pos_tween = create_tween()
