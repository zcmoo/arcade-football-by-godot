class_name PlayerState
extends Node
signal	state_transition_requested(new_state: Player.State, state_data: PlayerStateData)
var state_data : PlayerStateData = PlayerStateData.new()
var animation_player : AnimationPlayer = null
var player : Player = null
var ball : Ball = null
var teammate_detetion_area : Area2D = null
var ball_dection_area : Area2D = null
var own_goal : Goal = null
var target_goal : Goal = null
var ai_behavior : AIBehavior = null


func setup(context_player: Player, context_data: PlayerStateData, context_animation_player: AnimationPlayer, context_ball: Ball, context_teammate_detection_area: Area2D, context_ball_dection_area: Area2D, context_own_goal: Goal, context_target_goal: Goal, context_ai_behavior: AIBehavior) -> void:
	player = context_player
	animation_player = context_animation_player
	state_data = context_data
	ball = context_ball
	teammate_detetion_area = context_teammate_detection_area
	ball_dection_area = context_ball_dection_area
	own_goal = context_own_goal
	target_goal = context_target_goal
	ai_behavior = context_ai_behavior

func transition_state(new_state: Player.State, state_data: PlayerStateData = PlayerStateData.new()) ->void:
	state_transition_requested.emit(new_state, state_data)

func on_animation_complete() -> void:
	pass # override me
