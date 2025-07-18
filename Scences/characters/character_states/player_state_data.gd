class_name PlayerStateData
var shot_direction : Vector2
var shot_power : float
var hurt_direction : Vector2
var pass_target : Player
var reset_position: Vector2


static func build() -> PlayerStateData:
	return PlayerStateData.new()

func set_shot_direction(direction: Vector2) -> PlayerStateData:
	shot_direction = direction
	return self

func set_shot_power(power: float) -> PlayerStateData:
	shot_power = power
	return self

func set_hurt_direction(dirction: Vector2) -> PlayerStateData:
	hurt_direction = dirction
	return self

func set_pass_target(player: Player) -> PlayerStateData:
	pass_target = player
	return self

func set_reset_position(position: Vector2) -> PlayerStateData:
	reset_position = position
	return self
