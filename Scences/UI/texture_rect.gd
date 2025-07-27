class_name BacketFlag
extends TextureRect
@onready var border = %Border
@onready var score_label = %ScoreLabel


func set_as_current_team() -> void:
	border.visible = true	

func set_as_winner(score: String) -> void:
	score_label.text = score
	score_label.visible = true
	border.visible = false

func set_as_loser() -> void:
	modulate = Color(0.2, 0.2, 0.2, 1)
	border.visible = false
