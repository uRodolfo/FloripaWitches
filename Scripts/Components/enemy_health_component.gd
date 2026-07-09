class_name EnemyHealthComponent
extends HealthComponent

@export var blink_interval: float = 0.1
@export var blink_duration: float = 0.4

@onready var blink_timer: Timer = $BlinkInterval

var blinking := false
var elapsed := 0.0

func _ready():
	blink_timer.wait_time = blink_interval
	blink_timer.one_shot = false

func _damage(damage_amount: float) -> void:
	damage(damage_amount)
	start_blink()

func start_blink():
	if blinking:
		return

	blinking = true
	elapsed = 0.0
	blink_timer.start()

func _process(delta):
	if !blinking:
		return

	elapsed += delta

	if elapsed >= blink_duration:
		blinking = false
		blink_timer.stop()

		if owner:
			owner.visible = true

func _on_blink_interval_timeout():
	if owner:
		owner.visible = !owner.visible
