class_name Goal
extends Node2D
@onready var back_net_area : Area2D = %BackNetArea


func _ready() -> void:
	back_net_area.body_entered.connect(on_ball_enter_back_net.bind())

func on_ball_enter_back_net(ball: Ball) -> void:	
	ball.stop()
