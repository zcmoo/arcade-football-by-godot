class_name BallStateFreeform
extends BallState
const MAX_BALL_HEIGHT = 30
var time_since_freeform = Time.get_ticks_msec()


func _enter_tree() -> void:
	player_dection_area.body_entered.connect(on_player_enter.bind())
	
func on_player_enter(body: Player) -> void:
	if body.can_carry_ball() and ball.height < MAX_BALL_HEIGHT:
		ball.carrier = body
		body.control_ball()
		transition_state(Ball.State.ARRIED) 

func _process(delta: float) -> void:
	player_dection_area.monitoring = (Time.get_ticks_msec() - time_since_freeform > state_data.lock_duration)
	set_ball_animation_from_velocity()
	var friction = ball.friction_air if ball.height > 0 else ball.friction_ground
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, ball.BOUNCINESS)
	move_and_bounce(delta)

func can_air_interact() -> bool:
	return true
