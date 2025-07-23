class_name PlayerStateVolleyKick
extends PlayerState
const BONUS_POWER = 2.5
const BALL_HEIGHT_MAX = 20.0
const BALL_HEIGHT_MIN = 1.0


func _enter_tree() -> void:
	animation_player.play("volley_kick")
	ball_dection_area.body_entered.connect(on_ball_enter.bind())

func on_ball_enter(contact_ball: Ball) -> void:
	if contact_ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX):
		var destination = target_goal.get_random_target_position()
		var drection = ball.position.direction_to(destination)
		SoundPlayer.play(SoundPlayer.Sound.POWERSHOT)
		contact_ball.shoot(drection * player.power * BONUS_POWER)

func on_animation_complete() -> void:
	transition_state(Player.State.RECOVERING)
