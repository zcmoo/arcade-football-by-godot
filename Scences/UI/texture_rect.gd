class_name BacketFlag
extends TextureRect
@onready var border = %Border
@onready var score_label = %ScoreLabel


func set_as_current_teamI() -> void:
	border.visible = true	

func set_as_winner(score: String) -> void:
	score_label.text = score
	score_label.visble = true	

func set_as_loser() -> void:
	modulate = Color(0.2, 0.2, 0.2, 1)
