class_name ActorContainer
extends Node2D
const PLAYER_PREFAB = preload("res://Scences/characters/player.tscn")
@export var ball : Ball
@export var goal_home : Goal
@export var goal_away : Goal
@export var team_home : String
@export var team_away : String
@onready var sqawns : Node2D = %Spanwns


func _ready() -> void:
	sqawn_players(team_home, goal_home)
	sqawns.scale.x = -1
	sqawn_players(team_away, goal_away)
	var player1 : Player = get_children().filter(func(p): return p is Player)[0]
	player1.control_scheme = Player.ControlScheme.P1
	var player2 : Player = get_children().filter(func(p): return p is Player)[1]
	player2.control_scheme = Player.ControlScheme.P2
	player1.set_control_texture()
	player2.set_control_texture()
	
func sqawn_players(country: String, own_goal: Goal) -> void:
	var players = DataLoadere.get_squad(country)
	var target_goal = goal_home if own_goal == goal_away else goal_away
	for i in players.size():
		var player_position = sqawns.get_child(i).global_position as Vector2
		var player_data = players[i] as PlayerResource
		var player = spawn_player(player_position, own_goal, target_goal, player_data)
		add_child(player)

func spawn_player(player_position: Vector2, own_goal: Goal, target_goal: Goal, player_data: PlayerResource):
	var player = PLAYER_PREFAB.instantiate()
	player.initialize(player_position, ball, own_goal, target_goal, player_data )
	return player
