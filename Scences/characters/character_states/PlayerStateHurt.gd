class_name PlayerStateHurt
extends PlayerState
const DURARION_HURT = 1000
const AIR_FRICTION = 35
const HURT_HIGHT_VOLOCITY = 3
const BALL_TUMBLE_SPEED = 100
var time_start_hurt = Time.get_ticks_msec()


func _enter_tree() -> void:
	animation_player.play("hurt")
	time_start_hurt = Time.get_ticks_msec()
	player.height_velocity = HURT_HIGHT_VOLOCITY
	if ball.carrier == player:
		ball.tumble(state_data.hurt_direction * BALL_TUMBLE_SPEED)
		GameEvents.impact_receive.emit(player.position, false)

func _process(delta: float) -> void:
	if Time.get_ticks_msec() - time_start_hurt > DURARION_HURT:
		transition_state(Player.State.RECOVERING)
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
