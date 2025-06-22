class_name PlayerStateTackling
extends PlayerState
const DURATION_TACKLIE = 200
var time_state_tackle := Time.get_ticks_msec()
func _enter_tree() -> void:
	animation_player.play("tackle")
	time_state_tackle = Time.get_ticks_msec()
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_state_tackle > DURATION_TACKLIE:
		state_transition_requested.emit(Player.State.MOVING)
