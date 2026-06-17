extends Node2D
@export var normal: Texture2D
@export var pintado: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	$Sprite2D.texture = pintado
	pass # Replace with function body.
