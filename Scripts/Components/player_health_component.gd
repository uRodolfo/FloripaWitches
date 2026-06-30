extends HealthComponent
class_name PlayerHealthComponent

@export var iframe_duration: float = 1.0
@export var blink_interval: float = 0.1

@onready var _iframes_timer: Timer = $IFramesTimer
@onready var _iframes_blink_interval: Timer = $IFramesBlinkInterval

var invincible: bool = false

func _ready() -> void:
	_iframes_timer.wait_time = iframe_duration
	_iframes_timer.one_shot = true

	_iframes_blink_interval.wait_time = blink_interval
	_iframes_blink_interval.one_shot = false

func damage(amount: float) -> void:
	if invincible:
		return

	super.damage(amount)

	if dead:
		return

	start_iframes()

func start_iframes() -> void:
	invincible = true
	_iframes_timer.start()
	_iframes_blink_interval.start()

func _on_i_frames_timer_timeout() -> void:
	invincible = false
	_iframes_blink_interval.stop()

	if owner:
		owner.visible = true

func _on_i_frames_blink_interval_timeout() -> void:
	if owner:
		owner.visible = !owner.visible
