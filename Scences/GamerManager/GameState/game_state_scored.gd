class_name GameStaeScored
extends GameState
const DURATION_CELEBRATING = 3000
var time_since_celebration = Time.get_ticks_msec()


func _enter_tree() -> void:
	manager.increase_score(state_data.country_scored_on)
	time_since_celebration = Time.get_ticks_msec()

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_since_celebration > DURATION_CELEBRATING:
		transition_state(GameManager.State.RESET, state_data)
