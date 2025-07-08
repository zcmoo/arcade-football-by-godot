class_name AIBehavior 
extends  Node
var ball : Ball = null
var player : Player = null
var DURTION_AI_TICK_FREQUENCY = 200
var time_since_last_ai_tick = Time.get_ticks_msec()
var opponent_detection_area : Area2D = null


func _ready() -> void:
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, DURTION_AI_TICK_FREQUENCY)

func setup(context_player: Player, context_ball: Ball, context_opponent_detection_area: Area2D) -> void:
	player = context_player
	ball = context_ball
	opponent_detection_area = context_opponent_detection_area

func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_ai_tick > DURTION_AI_TICK_FREQUENCY:
		perform_ai_movement()
		perform_ai_decision()

func perform_ai_movement() -> void:
	pass # override me

func perform_ai_decision() -> void:
	pass # override me

func get_onduty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)

func is_ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country == player.country

func	 face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.heading = player.heading * -1

func is_possessed_by_opponent() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country != player.country

func has_opponent_nearby() -> bool:
	var players = opponent_detection_area.get_overlapping_bodies()
	var opponent_count = 0
	var teammate_count = 0
	for player_body in players:
		if player_body is Player and player_body.country != player.country:
			opponent_count += 1
		else:
			teammate_count += 1
	return opponent_count > 2 and teammate_count >= 1
	
