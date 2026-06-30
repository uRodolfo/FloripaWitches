#Variação de HealthComponent que aplica a lógica de tomar dano do player

extends HealthComponent

@onready var _iframes_timer : Timer = $IFramesTimer
@onready var _iframes_blink_interval : Timer = $IFramesBlinkInterval

var invincible : bool = false

func damage(damage: float):
	if !invincible:                     #Checar se o player não está invencível (iframes) para aplicar o dano
		super.damage(damage)                   #Chamar o método da classe herdada
	
		#Aplicar IFrames
		invincible = true
		_iframes_timer.start()
		_iframes_blink_interval.start()

func _on_i_frames_timer_timeout() -> void:
	invincible = false
	_iframes_blink_interval.stop()
	owner.visible = true

func _on_i_frames_blink_interval_timeout() -> void:
	owner.visible = !owner.visible
