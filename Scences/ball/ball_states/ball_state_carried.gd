class_name BallStateCarried
extends BallState

func _enter_tree() -> void:
	assert(carrier != null)
func _process(delta: float) -> void:
	ball.position = carrier.position
