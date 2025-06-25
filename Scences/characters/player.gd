class_name Player
extends CharacterBody2D
const CONTROL_SCHEME_MAP : Dictionary = {
	ControlScheme.CPU : preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1 : preload("res://assets/art/props/1p.png"),
	ControlScheme.P2 : preload("res://assets/art/props/2p.png")
}
const GRAVITY = 8.0
enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPRING_SHOOT, SHOOTING, PASSING, HEADER, VOLLEY_KICK, BICYCLE_KICK}
@export var power : float
@export var speed : float
@export var control_scheme : ControlScheme
@export var ball : Ball
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var player_sprite : Sprite2D = %PlayerSprite
@onready var teammate_detection_area : Area2D = %TeammateDetctionArea
@onready var control_sprite : Sprite2D = %ControlSprite
@onready var ball_dection_area : Area2D = %BallDectionArea
var current_state : PlayerState = null 
var state_factory := PlayerStateFactory.new()
var heading := Vector2.RIGHT
var height = 0.0
var height_velocity = 0.0


func _ready() -> void:
	set_control_texture()
	switch_state(State.MOVING) # 初始化状态节点

func _process(delta: float) -> void:
	flip_sprite()
	set_sprite_visiblity()
	process_gravity(delta)
	move_and_slide()

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free() # 销毁掉上一个状态子节点
	current_state = state_factory.get_fresh_state(state) # 实例化
	current_state.setup(self, state_data, animation_player, ball, teammate_detection_area, ball_dection_area) # 为当前子节点安装必要组件依赖
	current_state.state_transition_requested.connect(switch_state.bind()) # 触发调用该方法的信号
	current_state.name = "PlayerStateMachine" + str(state) # 可视化
	call_deferred("add_child", current_state) # 将现在的状态子节点添加到父节点中

func set_movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
	elif velocity.x < 0:
		heading = Vector2.LEFT 

func flip_sprite() -> void:
	if heading == Vector2.RIGHT:
		player_sprite.flip_h = false
	elif heading == Vector2.LEFT:
		player_sprite.flip_h = true

func has_ball() -> bool:
	return ball.carrier == self

func on_annimation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()

func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_MAP[control_scheme]

func set_sprite_visiblity() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU

func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height < 0:
			height = 0
	player_sprite.position = Vector2.UP * height
