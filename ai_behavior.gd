class_name AIBehavior 
extends  Node
const SHOT_DISTANCE = 150
const SPREAD_ASSIST_FACTORY = 0.80
const SHOT_PROBABLITY = 0.5
var ball : Ball = null
var player : Player = null
var DURTION_AI_TICK_FREQUENCY = 200
var time_since_last_ai_tick = Time.get_ticks_msec()


func _ready() -> void:
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, DURTION_AI_TICK_FREQUENCY)

func setup(context_player: Player, context_ball: Ball) -> void:
	player = context_player
	ball = context_ball

func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_ai_tick > DURTION_AI_TICK_FREQUENCY:
		perform_ai_movement()
		perform_ai_decision()

func perform_ai_movement() -> void:
	var total_steering_force = Vector2.ZERO
	if player.has_ball():
		total_steering_force += get_carrier_steering_force()
	elif player.role != Player.Role.GOALE:
		total_steering_force += get_onduty_steering_force()
		if is_ball_carried_by_teammate():
			total_steering_force += get_assist_formation_steering()
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed

func  perform_ai_decision() -> void:
	if ball.carrier == player:
		var target = player.target_goal.get_center_target_position()
		if player.position.distance_to(target) < SHOT_DISTANCE and randf() < SHOT_PROBABLITY:
			face_towards_target_goal()
			var shot_direction = player.position.direction_to(player.target_goal.get_random_target_position())
			var data = PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
			player.switch_state(Player.State.SHOOTING, data)

func get_onduty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)

func get_bicircular_weight(postion: Vector2, center_target: Vector2, inner_circle_radius: float, inner_circle_weight: float, outer_circle_radius: float, outer_circle_weight: float) -> float:
	var distance_to_center = postion.distance_to(center_target)
	if distance_to_center > outer_circle_radius:
		return outer_circle_weight
	elif distance_to_center < inner_circle_radius:
		return inner_circle_weight
	else:
		var distance_to_inner_radius = distance_to_center - inner_circle_radius
		var close_range_distance = outer_circle_radius - inner_circle_radius
		return lerp(inner_circle_weight, outer_circle_weight, distance_to_inner_radius / close_range_distance)

func get_carrier_steering_force() -> Vector2:
	var target = player.target_goal.get_center_target_position()
	var direction = player.position.direction_to(target)
	var weight = get_bicircular_weight(player.position, target, 100, 0, 150, 1)
	return weight * direction

func get_assist_formation_steering() -> Vector2:
	var spawn_distance = ball.carrier.spawn_position - player.spawn_position
	var assist_destinate = ball.carrier.position - spawn_distance * SPREAD_ASSIST_FACTORY
	var direction = player.position.direction_to(assist_destinate)
	var weight = get_bicircular_weight(player.position, assist_destinate, 30, 0.2, 60, 1.0)
	return weight * direction

func is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country == player.country

func	 face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.heading = player.heading * -1
	
