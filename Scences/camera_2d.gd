class_name  Camera
extends Camera2D
const DISTANCE_TARGET = 100.0
const SMOOTH_BALL_CARRIED = 2
const SMOOTH_BALL_DEFALULT = 8
@export var ball : Ball


func _process(delta: float) -> void:
	if ball.carrier != null:
		position = ball.carrier.position + ball.carrier.heading * DISTANCE_TARGET
		position_smoothing_speed = SMOOTH_BALL_CARRIED
	else:
		position = ball.position
		position_smoothing_speed = SMOOTH_BALL_DEFALULT

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
	
