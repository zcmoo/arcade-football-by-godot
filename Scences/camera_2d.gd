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
