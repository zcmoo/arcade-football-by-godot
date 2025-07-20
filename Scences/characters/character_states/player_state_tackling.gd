class_name PlayerStateTackling
extends PlayerState
const DURATION_PRIOR_RECOVERY = 200
const GROUND_FRICTION = 250.0
var is_tackle_complete = false
var time_finish_tackle := Time.get_ticks_msec()


func _enter_tree() -> void:
	animation_player.play("tackle")
	tackle_damage_emitter_area.monitoring = true	

func _process(delta: float) -> void:
	if not is_tackle_complete:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * GROUND_FRICTION)
		if player.velocity == Vector2.ZERO:
			is_tackle_complete = true
			time_finish_tackle = Time.get_ticks_msec()
	elif Time.get_ticks_msec() - time_finish_tackle > DURATION_PRIOR_RECOVERY:
		transition_state(Player.State.RECOVERING)

func can_carry_ball() -> bool:
	return true 

func _exit_tree() -> void:
	tackle_damage_emitter_area.monitoring = false
