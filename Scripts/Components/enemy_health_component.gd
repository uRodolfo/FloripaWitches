class_name EnemyHealthComponent
extends HealthComponent


signal damaged_by(
	damage_amount: float,
	source: Node2D
)


@export var blink_interval: float = 0.1
@export var blink_duration: float = 0.4


@onready var blink_timer: Timer = $BlinkInterval


var blinking: bool = false
var elapsed: float = 0.0


func _ready() -> void:
	blink_timer.wait_time = blink_interval
	blink_timer.one_shot = false


func _damage(
	damage_amount: float
) -> void:
	damage(damage_amount)

	start_blink()


func damage_from(
	damage_amount: float,
	source: Node2D
) -> void:
	_damage(damage_amount)

	damaged_by.emit(
		damage_amount,
		source
	)


func start_blink() -> void:
	if blinking:
		return

	blinking = true
	elapsed = 0.0

	blink_timer.start()


func _process(delta: float) -> void:
	if not blinking:
		return

	elapsed += delta

	if elapsed >= blink_duration:
		blinking = false

		blink_timer.stop()

		if owner:
			owner.visible = true


func _on_blink_interval_timeout() -> void:
	if owner:
		owner.visible = not owner.visible
