class_name ActorContainer
extends Node2D
const PLAYER_PREFAB = preload("res://Scences/characters/player.tscn")
@export var ball : Ball
@export var goal_home : Goal
@export var goal_away : Goal
@onready var sqawns : Node2D = %Spanwns
var squad_home : Array[Player] = []
var squad_away : Array[Player] = []
var DURTION_WEIGHT_CACHE = 200
var time_since_last_cache_refresh = Time.get_ticks_msec()


func _ready() -> void:
	squad_home = sqawn_players(GameManager.contries[0], goal_home)
	goal_home.initialize(GameManager.contries[0])
	sqawns.scale.x = -1
	squad_away = sqawn_players(GameManager.contries[1], goal_away)
	goal_away.initialize(GameManager.contries[1])
	var player1 : Player = get_children().filter(func(p): return p is Player)[3]
	player1.control_scheme = Player.ControlScheme.P1
	player1.set_control_texture()
	#var player2 : Player = get_children().filter(func(p): return p is Player)[1]
	#player2.control_scheme = Player.ControlScheme.P2
	#player2.set_control_texture()

func sqawn_players(country: String, own_goal: Goal) -> Array[Player]:
	var player_node : Array[Player] = []
	var players = DataLoadere.get_squad(country)
	var target_goal = goal_home if own_goal == goal_away else goal_away
	for i in players.size():
		var player_position = sqawns.get_child(i).global_position
		var player_data = players[i] 
		var player = spawn_player(player_position, own_goal, target_goal, player_data, country)
		player_node.append(player)
		player.name = player_data["full_name"]
		add_child(player)
	return player_node

func spawn_player(player_position: Vector2, own_goal: Goal, target_goal: Goal, player_data: PlayerResource, country: String):
	var player = PLAYER_PREFAB.instantiate()
	player.initialize(player_position, ball, own_goal, target_goal, player_data, country)
	player.swap_requested.connect(on_player_swap_request.bind())
	return player

func set_on_duty_weights() -> void:
	for squad in [squad_away, squad_home]:
		var cpu_player : Array[Player] = squad.filter(func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALE)
		cpu_player.sort_custom(func(p1: Player, p2:Player): return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position))
		for i in range(cpu_player.size()):
			cpu_player[i].weight_on_duty_steering = 1 - ease(float(i) / 10.0, 0.1)

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_since_last_cache_refresh > DURTION_WEIGHT_CACHE:
		time_since_last_cache_refresh = Time.get_ticks_msec()
		set_on_duty_weights()

func on_player_swap_request(requester: Player) -> void:
	var squad = squad_home if requester.country == squad_home[0].country else squad_away
	var cpu_players : Array[Player] = squad.filter(func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.GOALE)
	cpu_players.sort_custom(func(p1: Player, p2:Player): return p1.position.distance_squared_to(ball.position) < p2.position.distance_squared_to(ball.position))
	var closest_cpu_to_ball: Player = cpu_players[0]
	if closest_cpu_to_ball.position.distance_squared_to(ball.position) < requester.position.distance_squared_to(ball.position):
		var player_control_scheme = requester.control_scheme
		closest_cpu_to_ball.control_scheme = player_control_scheme
		closest_cpu_to_ball.set_control_texture()
		requester.control_scheme = Player.ControlScheme.CPU
		requester.set_control_texture()
