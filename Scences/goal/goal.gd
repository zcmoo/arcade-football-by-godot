class_name Goal
extends Node2D
@onready var back_net_area : Area2D = %BackNetArea
@onready var targets : Node2D = %Targets
@onready var camera : Camera2D = %Camera2D
@onready var scoring_area : Area2D = %ScoringArea
var country = "" 


func _ready() -> void:
	back_net_area.body_entered.connect(on_ball_enter_back_net.bind())
	scoring_area.body_entered.connect(on_ball_enter_scoring_area.bind())

func on_ball_enter_back_net(ball: Ball) -> void:	
	ball.stop()
	camera.shake()

func initialize(context_country: String) -> void:
	country = context_country

func on_ball_enter_scoring_area(ball: Ball) -> void:
	GameEvents.team_scored.emit(country)

func get_random_target_position() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position

func get_center_target_position() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position

func get_top_target_position() -> Vector2:
	return targets.get_child(0).global_position
	
func get_bottom_target_position() -> Vector2:
	return targets.get_child(targets.get_child_count() - 1).global_position

func get_scoring_area() -> Area2D:
	return scoring_area
