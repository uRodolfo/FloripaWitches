extends Node2D

@onready var screen_size: Vector2 = get_viewport_rect().size
@export var player_node = CharacterBody2D
@export var camera_node = Camera2D

func _ready():
	set_screen_position()
	await get_tree().process_frame
	camera_node.position_smoothing_enabled = true
	camera_node.position_smoothing_speed = 7.0

func _process(delta: float) -> void:
	set_screen_position()

func set_screen_position():
	if not player_node == null:
		var player_pos = player_node.global_position
		# Snapping de camera entre salas
		# Divide-se a posição do player pela sala e arredonda-se para baixo para se obter a distância do player da origem
		# medida em número de câmera (por exemplo, o jogador está a 4 câmeras da origem). Então, multiplica-se
		# o valor pelo tamanho da câmera para obter a distância em metros, adicionando metade do tamanho da câmera no
		# final para que a câmera fique centrada na sala.
		var x = floor(player_pos.x / screen_size.x) * screen_size.x + screen_size.x / 2
		var y = floor(player_pos.y / screen_size.y) * screen_size.y + screen_size.y / 2
		global_position = Vector2(x, y)
