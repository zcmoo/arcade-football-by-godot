class_name GameStaeScored
extends GameState
const DURATION_CELEBRATING = 3000
var time_since_celebration = Time.get_ticks_msec()


func _enter_tree() -> void:
	var index_contry_scring = 1 if state_data.country_scored_on == manager.contries[0] else 0
	manager.socre[index_contry_scring] += 1
	time_since_celebration = Time.get_ticks_msec()
	print(manager.contries[index_contry_scring])

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_since_celebration > DURATION_CELEBRATING:
		transition_state(GameManager.State.RESET, state_data)
