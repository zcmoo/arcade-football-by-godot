class_name PlayerStateMouning
extends PlayerState 


func _enter_tree() -> void:
	animation_player.play("moun")
	player.velocity = Vector2.ZERO
