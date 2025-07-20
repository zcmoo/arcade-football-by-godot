class_name BallStateFactory
var states: Dictionary


func _init() -> void:
	states = {
		Ball.State.ARRIED: BallStateCarried,
		Ball.State.FREEFORM: BallStateFreeform,
		Ball.State.SHOT: BallStateShot
	}

func get_fresh_state(state: Ball.State) -> BallState:
	assert(states.has(state), "state don't exist!")
	return states.get(state).new()
