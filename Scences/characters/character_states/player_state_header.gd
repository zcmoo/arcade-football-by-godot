class_name PlayerStateHeader
extends PlayerState
const HEIGHT_START = 0.1
const HEIGHT_VELOCITY = 1.5
const BONUS_POWER = 5.0
const BALL_HEIGHT_MAX = 30.0
const BALL_HEIGHT_MIN = 1.0


func _enter_tree() -> void:
	animation_player.play("header")
	player.height = HEIGHT_START
	player.height_velocity = HEIGHT_VELOCITY
	ball_dection_area.body_entered.connect(on_ball_enter.bind())

func on_ball_enter(contact_ball: Ball) -> void:
	if contact_ball.can_air_connect(BALL_HEIGHT_MIN, BALL_HEIGHT_MAX):
		contact_ball.shoot(player.velocity.normalized() * player.power * BONUS_POWER)

func _process(_delta: float) -> void:
	if player.height == 0:
		transition_state(Player.State.RECOVERING)
