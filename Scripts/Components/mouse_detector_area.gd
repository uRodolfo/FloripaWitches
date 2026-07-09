class_name MofasTargetDetector
extends Area2D


@export var target: Node2D
@export var mofas_group: StringName = &"Mofas"


func _ready() -> void:
	if not target:
		target = get_parent() as Node2D

	input_pickable = true


func _input_event(
	_viewport: Viewport,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if not event.is_action_pressed(
		&"AttackMofas"
	):
		return

	var mofas := _get_mofas()

	if not mofas:
		push_error(
			"MOFAS NÃO ENCONTRADO"
		)
		return

	if not is_instance_valid(target):
		return

	print(
		"INIMIGO SELECIONADO: ",
		target
	)

	mofas.start_attack(
		target
	)


func _get_mofas() -> Puppet:
	return get_tree().get_first_node_in_group(
		mofas_group
	) as Puppet
