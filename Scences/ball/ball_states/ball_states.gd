class_name BallState
extends Node
signal	state_transition_requested(new_state: Ball.State)
var player_dection_area : Area2D = null
var ball : Ball = null
var carrier : Player = null 
var animation_player : AnimationPlayer = null	
var sprite : Sprite2D = null


func setup(context_ball:Ball, context_player_dection_area: Area2D, context_carrier: Player, context_animation_player: AnimationPlayer, context_sprite: Sprite2D) -> void:
	ball = context_ball
	player_dection_area = context_player_dection_area
	carrier = context_carrier
	animation_player = context_animation_player
	sprite = context_sprite
