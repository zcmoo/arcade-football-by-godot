class_name Player
extends CharacterBody2D
enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREPPRING_SHOOT, SHOOTING}
@export var power : float
@export var speed : float
@export var control_scheme : ControlScheme
@export var ball : Ball
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var player_sprite : Sprite2D = %PlayerSprite
var current_state : PlayerState = null 
var state_factory := PlayerStateFactory.new()
var heading := Vector2.RIGHT


func _ready() -> void:
	switch_state(State.MOVING) # 初始化状态节点

func _process(_delta: float) -> void:
	flip_sprite()
	move_and_slide()

func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free() # 销毁掉上一个状态子节点
	current_state = state_factory.get_fresh_state(state) # 实例化
	current_state.setup(self, state_data, animation_player, ball) # 为当前子节点安装必要组件依赖
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
