class_name AIBehavior 
extends  Node
var ball : Ball = null
var player : Player = null
var opponent_detection_area : Area2D = null
var teammate_detection_area : Area2D = null
var DURTION_AI_TICK_FREQUENCY = 150
var time_since_last_ai_tick = Time.get_ticks_msec()


func _ready() -> void:
	time_since_last_ai_tick = Time.get_ticks_msec() + randi_range(0, DURTION_AI_TICK_FREQUENCY)

func setup(context_player: Player, context_ball: Ball, context_opponent_detection_area: Area2D, context_teammate_detetion_area: Area2D) -> void:
	player = context_player
	ball = context_ball
	opponent_detection_area = context_opponent_detection_area
	teammate_detection_area = context_teammate_detetion_area

func process_ai() -> void:
	if Time.get_ticks_msec() - time_since_last_ai_tick > DURTION_AI_TICK_FREQUENCY:
		time_since_last_ai_tick = Time.get_ticks_msec()
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

func is_possessed_by_opponent() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.country != player.country

func has_opponent_nearby() -> bool:
	var players = opponent_detection_area.get_overlapping_bodies()
	var opponent_count: int
	opponent_count = 0
	for player_body in players:
		if player_body is Player and player_body.country != player.country:
			opponent_count += 1
	return opponent_count > 0

func has_teammate_in_view() -> bool:
	var players_in_view = teammate_detection_area.get_overlapping_bodies()
	var teammate_count: int
	teammate_count = 0
	for player_body in players_in_view:
		if player_body is Player and player_body != player and player_body.role != Player.Role.GOALE and player_body.country == player.country:
			teammate_count += 1
	return teammate_count > 0
