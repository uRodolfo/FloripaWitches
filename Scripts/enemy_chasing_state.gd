extends State

@export var enemy : Enemy
@export var navigation_update_interval: Timer
@export var attacking_state : State
@export var attacking_transition_player_distance : float = 100.0
@export var roaming_transition_player_distance : float = 350.0


func physics_update(_delta: float) -> void:
	if not is_instance_valid(enemy.player):
		return
	enemy.pathfind_and_move_to(enemy.player.global_position)

	aggro_range_check()
	attack_when_close()

func enter() -> void:
	navigation_update_interval.start()
	navigation_update_interval.timeout.emit()
	
func exit() -> void:
	navigation_update_interval.stop()

func aggro_range_check() -> void:
	#Voltar ao state Roaming caso o player esteja muito longe
	var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
	if distance_to_player >= roaming_transition_player_distance:
		transition_to("roaming")
		return

func attack_when_close() -> void:
	#Raycasting para saber se o player está no campo de visão
	var mofas_entity = get_tree().get_nodes_in_group(&"Mofas")[0]
	var space_state = enemy.get_world_2d().direct_space_state
	var raycast_query = PhysicsRayQueryParameters2D.create(enemy.global_position, enemy.player.global_position)
	raycast_query.exclude = [self, mofas_entity]
	var raycast_result = space_state.intersect_ray(raycast_query)
	
	#Transicionar para o ataque quando estiver vendo o player e perto o suficiente
	if raycast_result:
		var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
		if distance_to_player <= attacking_transition_player_distance and raycast_result["collider"] == enemy.player:
			if attacking_state.can_attack:
				transition_to("attacking")
				return
