class_name Player
extends CharacterBody2D
signal swap_requested(player: Player)
const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU : preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1 : preload("res://assets/art/props/1p.png"),
	ControlScheme.P2 : preload("res://assets/art/props/2p.png")
}
const GRAVITY = 8.0
const BALL_CONTROL_HEIGHT_MAX = 10
const WALK_ANIM_THRESHDLD = 0.6
enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPRING_SHOOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK, CHEST_CONTROL, HURT, DIVING, CELEBRATING, MOUNING, RESET}
enum Role {GOALE, DEFNSE, MIDFIELD, OFFNSE}
enum SkinColor {LIGHT, MEDIUM, DARK}
@export var power: float
@export var speed: float
@export var control_scheme: ControlScheme
@export var ball: Ball
@export var own_goal: Goal
@export var target_goal: Goal
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_sprite: Sprite2D = %PlayerSprite
@onready var teammate_detection_area: Area2D = %TeammateDetctionArea
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var ball_dection_area: Area2D = %BallDectionArea
@onready var tackle_damage_emitter_area: Area2D = %TackleDamageEmitterArea
@onready var opponent_detection_area: Area2D = %OpponentDetectionArea
@onready var permanent_damage_emitter_area: Area2D = %PermanentDamageEmitter
@onready var GoalierHands: CollisionShape2D = %GoalierHands
@onready var run_particle: GPUParticles2D = %RunParticles
@onready var root_particle:  Node2D = %RootParticles
var actors_container: Node2D
var country = ""
var current_state : PlayerState = null 
var state_factory := PlayerStateFactory.new()
var ai_behavior_factory = AiBehaviorFactory.new()
var current_ai_behavior = null
var heading := Vector2.RIGHT
var height = 0.0
var height_velocity = 0.0
var fullname = ""
var role = Player.Role.MIDFIELD
var skin_color = Player.SkinColor.MEDIUM
var spawn_position = Vector2.ZERO
var kickoff_position = Vector2.ZERO
var weight_on_duty_steering = 0.0


func _ready() -> void:
	actors_container = get_tree().get_root().get_node("World/ActorsContainer")
	set_control_texture()
	setup_ai_behavior()
	set_shader_properties()
	run_particle.emitting = false
	permanent_damage_emitter_area.monitoring = role == self.Role.GOALE
	GoalierHands.disabled = role != self.Role.GOALE
	tackle_damage_emitter_area.body_entered.connect(on_tackle_player.bind())
	permanent_damage_emitter_area.body_entered.connect(on_tackle_player.bind())
	GameEvents.game_over.connect(on_game_over.bind())
	GameEvents.team_scored.connect(on_team_scored.bind())
	spawn_position = position
	var initial_position = kickoff_position if country == GameManager.contries[0] else spawn_position
	switch_state(State.RESET, PlayerStateData.build().set_reset_position(initial_position))

func _process(delta: float) -> void:
	flip_sprite()
	set_sprite_visiblity()
	process_gravity(delta)
	move_and_slide()

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free() # 如果有上一个状态子节点就销毁掉上一个状态子节点
	current_state = state_factory.get_fresh_state(state) # 实例化当前状态
	current_state.setup(self, state_data, animation_player, ball, teammate_detection_area, ball_dection_area, own_goal, target_goal, current_ai_behavior, tackle_damage_emitter_area, actors_container) # 为当前玩家状态子节点安装必要组件依赖
	current_state.state_transition_requested.connect(switch_state.bind()) # 递归切换下一个状态
	current_state.name = "PlayerStateMachine" + str(state) # 可视化子节点名字
	call_deferred("add_child", current_state) # 将现在的状态子节点添加到父节点中

func set_movement_animation() -> void:
	var vel_length = velocity.length()
	if  vel_length < 1:
		animation_player.play("idle")
	elif vel_length < speed * WALK_ANIM_THRESHDLD:
		animation_player.play("walk")
	else:
		animation_player.play("run")

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT 

func flip_sprite() -> void:
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
		tackle_damage_emitter_area.scale.x = 1
		opponent_detection_area.scale.x = 1
		root_particle.scale.x = 1
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true
		tackle_damage_emitter_area.scale.x = -1
		opponent_detection_area.scale.x = -1
		root_particle.scale.x = -1

func has_ball() -> bool:
	if ball:
		return ball.carrier == self
	return false

func is_ready_to_kickoff() -> bool:
	return current_state != null and current_state.is_ready_for_kickoff()

func on_annimation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func set_sprite_visiblity() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU
	run_particle.emitting = (velocity.length() == speed)
	
func process_gravity(delta: float) -> void:
	if height > 0 or height_velocity > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height < 0:
			height = 0
	player_sprite.position = Vector2.UP * height

func control_ball() -> void:
	if ball.height > BALL_CONTROL_HEIGHT_MAX:
		switch_state(Player.State.CHEST_CONTROL)

func initialize(context_player_position: Vector2, context_ball: Ball, context_own_goal: Goal, context_target_goal: Goal, context_player_data: PlayerResource, context_country: String, context_kickoff_postion: Vector2) -> void:
	position = context_player_position
	ball = context_ball
	own_goal = context_own_goal
	target_goal = context_target_goal
	speed = context_player_data.speed
	power = context_player_data.power
	role = context_player_data.role
	skin_color = context_player_data.skin_color
	fullname = context_player_data.full_name
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT
	country = context_country
	kickoff_position = context_kickoff_postion

func set_shader_properties() -> void:
	player_sprite.material.set_shader_parameter("skin_color", skin_color)
	var countries = DataLoadere.get_countries()
	var country_color = countries.find(country)
	country_color = clamp(country_color, 0 , countries.size() - 1)
	player_sprite.material.set_shader_parameter("team_color", country_color)

func setup_ai_behavior() -> void:
	current_ai_behavior = ai_behavior_factory.get_ai_behavior(role)
	current_ai_behavior.setup(self, ball, opponent_detection_area, teammate_detection_area)
	current_ai_behavior.name = "AI Behavior"
	add_child(current_ai_behavior)

func is_facing_target_goal() -> bool:
	var direction_to_target_goal = position.direction_to(target_goal.position)
	return heading.dot(direction_to_target_goal) > 0

func on_tackle_player(player: Player) -> void:
	if player != self and player.country != country and player == ball.carrier:
		player.get_hurt(position.direction_to(player.position))

func get_hurt(hurt_origin: Vector2) -> void:
	switch_state(Player.State.HURT, PlayerStateData.build().set_hurt_direction(hurt_origin)) 

func can_carry_ball() -> bool:
	return current_state != null and current_state.can_carry_ball()

func get_pass_request(player: Player) -> void:
	if ball.carrier == self and current_state != null and current_state.can_pass():
		switch_state(Player.State.PASSING, PlayerStateData.build().set_pass_target(player))

func on_team_scored(team_scored_on: String) -> void:
	if country == team_scored_on:
		switch_state(Player.State.MOUNING)
	else:
		switch_state(Player.State.CELEBRATING)

func face_towards_target_goal() -> void:
	if not self.is_facing_target_goal():
		self.heading = self.heading * -1

func set_control_scheme(scheme: ControlScheme) -> void:
	control_scheme = scheme
	set_control_texture()

func on_game_over(winner_team: String) -> void:
	if country == winner_team:
		switch_state(Player.State.CELEBRATING)
	else:
		switch_state(Player.State.MOUNING)
