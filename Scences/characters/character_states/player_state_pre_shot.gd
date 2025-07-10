class_name PlayerStatePreshot
extends PlayerState
var time_start_shoot = Time.get_ticks_msec()
const DURATION_MAX_BONUS = 1000.0
const EASE_REWARD_FACTOR = 2.0
var shot_directin = Vector2.ZERO


func _enter_tree() -> void:
	animation_player.play("prep-kick")
	player.velocity = Vector2.ZERO
	time_start_shoot = Time.get_ticks_msec()
	shot_directin = player.heading

func _process(delta: float) -> void:
	shot_directin += KeyUtils.get_input_vector(player.control_scheme) * delta
	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var duration_press = clamp(Time.get_ticks_msec() - time_start_shoot, 0.0, DURATION_MAX_BONUS)
		var ease_time = duration_press / DURATION_MAX_BONUS
		var bonus = ease(ease_time, EASE_REWARD_FACTOR)
		var shot_power = player.power * (1 + bonus)
		shot_directin = shot_directin.normalized()
		var state_data = PlayerStateData.build().set_shot_power(shot_power).set_shot_direction(shot_directin)
		transition_state(Player.State.SHOOTING, state_data)

func can_pass() -> bool:
	return true	
