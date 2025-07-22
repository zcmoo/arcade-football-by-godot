class_name Camera
extends Camera2D
@export var ball : Ball
const DISTANCE_TARGET = 100.0
const SMOOTH_BALL_CARRIED = 2
const SMOOTH_BALL_DEFALULT = 8
const DURATION_SHAKE = 120
const SHAKE_INTENSITY = 5
var is_shaking = false
var time_start_shake = Time.get_ticks_msec()


func _init() -> void:
	GameEvents.impact_receive.connect(on_impact_receive.bind())

func _process(delta: float) -> void:
	if ball.carrier != null:
		position = ball.carrier.position + ball.carrier.heading * DISTANCE_TARGET
		position_smoothing_speed = SMOOTH_BALL_CARRIED
	else:
		position = ball.position
		position_smoothing_speed = SMOOTH_BALL_DEFALULT
	if is_shaking and Time.get_ticks_msec() - time_start_shake < DURATION_SHAKE:
		offset = Vector2(randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY), randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))
	else:
		is_shaking = false
		offset = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_scale"):
		set_zoom(Vector2(0.6, 0.6))
		return
	if event.is_action_released("camera_scale"):
		set_zoom(Vector2(1, 1))
		return

func shake() -> void:
	var shake_tween = create_tween()
	for i in range(3):
		shake_tween.tween_property(self, "offset", offset + Vector2(randi_range(-2, -1), 0), 0.1)
		shake_tween.tween_property(self, "offset", offset + Vector2(randi_range(4, 2), 0), 0.1)
		shake_tween.tween_property(self, "offset", Vector2.ZERO, 0.1)

func on_impact_receive(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		is_shaking = true
		time_start_shake = Time.get_ticks_msec()
