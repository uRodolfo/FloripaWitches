class_name StateMachine
extends Node


@export var initial_state: State


var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is not State:
			continue

		var state := child as State

		states[state.name.to_lower()] = state
		state.transitioned.connect(on_child_transition)

	if not initial_state:
		push_error("INITIAL STATE NÃO DEFINIDO")
		return

	current_state = initial_state
	current_state.enter()

	set_physics_process(true)


func _process(delta: float) -> void:
	if not current_state:
		return

	current_state.update(delta)


func _physics_process(delta: float) -> void:
	print(
		"SM PHYSICS | CURRENT STATE: ",
		current_state
	)

	if current_state:
		current_state.physics_update(delta)


func change_state(new_state: State) -> void:
	if not new_state:
		return

	if new_state == current_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()


func on_child_transition(
	state: State,
	new_state_name: String
) -> void:
	if state != current_state:
		return

	var new_state: State = states.get(
		new_state_name.to_lower()
	)

	if not new_state:
		push_error(
			"STATE NÃO ENCONTRADA: "
			+ new_state_name
		)
		return

	change_state(new_state)

func change_state_by_name(
	new_state_name: StringName
) -> void:
	var state_key: String = (
		String(new_state_name).to_lower()
	)

	var new_state: State = states.get(
		state_key
	)

	if not new_state:
		push_error(
			"STATE NÃO ENCONTRADA: "
			+ String(new_state_name)
		)
		return

	change_state(new_state)
