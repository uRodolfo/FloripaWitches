extends CPUParticles2D
class_name  CPUParticlesController

func _ready() -> void:
	finished.connect(queue_free)
	pass
	
func play_particles() -> void:
	var bullet_emitter := self.duplicate()
	bullet_emitter.emitting = true
	bullet_emitter.global_position = self.global_position
	get_tree().current_scene.add_child(bullet_emitter)
