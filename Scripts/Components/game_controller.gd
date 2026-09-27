extends Node
	
func set_game_state_flag(flag: StringName, value: bool) -> void:
	GlobalGameState.set(flag, value)
