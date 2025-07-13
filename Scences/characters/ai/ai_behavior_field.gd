class_name AiBehaviorField
extends AIBehavior
const SPREAD_ASSIST_FACTORY = 0.8
const TACLE_PROBABILITY = 0.3
const PASS_PROBABLITY = 0.3
const SHOT_PROBABLITY = 0.5
const TACKLE_DISTANCE = 15
const SHOT_DISTANCE = 150


func perform_ai_movement() -> void:
	var total_steering_force = Vector2.ZERO
	if player.has_ball():
		total_steering_force += get_carrier_steering_force()
	elif is_ball_carried_by_teammate():
		total_steering_force += get_assist_formation_steering_force()
	else:
		total_steering_force += get_onduty_steering_force()
		if total_steering_force.length_squared() < 1:
			if is_possessed_by_opponent():
				total_steering_force += get_spawn_steering_force()
			elif ball.carrier == null:
				total_steering_force += get_ball_proximity_steering_force()
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed

func perform_ai_decision() -> void:
	if is_possessed_by_opponent() and player.position.distance_to(ball.position) < TACKLE_DISTANCE and randf() < TACLE_PROBABILITY:
		player.switch_state(Player.State.TACKLING)
	if ball.carrier == player:
		var target = player.target_goal.get_center_target_position()
		if player.position.distance_to(target) < SHOT_DISTANCE and randf() < SHOT_PROBABLITY:
			face_towards_target_goal()
			var shot_direction = player.position.direction_to(player.target_goal.get_random_target_position())
			var data = PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
			player.switch_state(Player.State.SHOOTING, data)
		elif randf() < PASS_PROBABLITY and player.country == GameManager.contries[0] and has_opponent_nearby():
			player.switch_state(Player.State.PASSING)
		elif randf() < PASS_PROBABLITY and player.country == GameManager.contries[1] and has_opponent_nearby() and has_teammate_in_view():
			player.switch_state(Player.State.PASSING)
		#elif randf() < PASS_PROBABLITY and has_opponent_nearby() and has_teammate_in_view():
			#player.switch_state(Player.State.PASSING)

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

func get_assist_formation_steering_force() -> Vector2:
	var spawn_distance = ball.carrier.spawn_position - player.spawn_position
	var assist_destinate = ball.carrier.position - spawn_distance * SPREAD_ASSIST_FACTORY
	var direction = player.position.direction_to(assist_destinate)
	var weight = get_bicircular_weight(player.position, assist_destinate, 30, 0.2, 60, 1.0)
	return weight * direction

func get_ball_proximity_steering_force() -> Vector2:
	var weight: = get_bicircular_weight(player.position, ball.position, 50, 1, 120, 0)
	var direction = player.position.direction_to(ball.position)
	return weight * direction

func get_spawn_steering_force() -> Vector2:
	var weight = get_bicircular_weight(player.position, player.spawn_position, 30, 0, 100, 1)
	var direction = player.position.direction_to(player.spawn_position)
	return weight * direction
