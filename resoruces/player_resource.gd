class_name PlayerResource
extends Resource
@export var full_name : String
@export var skin_color : Player.SkinColor
@export var role : Player.Role
@export var power : float
@export var speed : float


func _init(player_name: String, player_skin_color: Player.SkinColor, player_role: Player.Role, player_power: float, player_speed: float) -> void:
	full_name = player_name
	skin_color = player_skin_color
	role = player_role
	speed = player_speed
	power = player_power
