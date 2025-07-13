class_name PlayerStateCelebrate
extends PlayerState
const CELEBRATE_HEIGHT = 2.0
const AIR_FRICTION = 35.0


func	 _enter_tree() -> void:
	animation_player.play("celebrate")
	player.height_velocity = CELEBRATE_HEIGHT

func _process(delta: float) -> void:
	if player.height == 0:
		animation_player.play("celebrate")
		player.height_velocity = CELEBRATE_HEIGHT
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
	
