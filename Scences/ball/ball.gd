class_name Ball
extends AnimatableBody2D
enum State {ARRIED, FREEFORM, SHOT}
var velocity := Vector2.ZERO
var state_factory := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null
var height = 0.0
var height_velocity = 0.0
const BOUNCINESS = 0.8
const DiSTANCE_HIGHT_PASS = 130
@onready var player_detection_area : Area2D = %PlayerDetectionArea
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var ball_sprite : Sprite2D = %BallSprite
@export var friction_air : float
@export var friction_ground : float


func _ready() -> void:
	switch_state(State.FREEFORM) # 初始化状态节点

func _process(delta: float) -> void:
	ball_sprite.position = Vector2.UP * height
	if self.position.x > 850:
		self.position = Vector2(802, 174)
	elif self.position.x < 0:
		self.position = Vector2(48, 174)

func switch_state(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)	
	current_state.setup(self, player_detection_area, carrier, animation_player, ball_sprite) #状态子节点所需依赖项(球的属性，播放器等)
	current_state.state_transition_requested.connect(switch_state.bind()) # 监听器
	current_state.name = "BallStateMachine" + str(state) # 可视化
	call_deferred("add_child", current_state) # 将现在的状态子节点添加到父节点中
	
func shoot(shot_velocity) -> void:
	velocity = shot_velocity
	carrier = null
	switch_state(Ball.State.SHOT)

func pass_to(destination: Vector2) -> void:
	var directon = position.direction_to(destination)
	var distance = position.distance_to(destination)
	var velocity_x = sqrt(2 * distance * friction_ground)
	velocity = velocity_x * directon
	if distance > DiSTANCE_HIGHT_PASS:
		height_velocity = BallState.GRAVITY * distance / (1.8 * velocity_x)
	carrier = null
	switch_state(Ball.State.FREEFORM)

func stop() -> void:
	velocity = Vector2.ZERO

func can_air_interact() -> bool:
	return current_state != null and current_state.can_air_interact()

func can_air_connect(air_connect_min_height: float, air_connect_max_height: float) -> bool:
	return height >= air_connect_min_height and height <= air_connect_max_height
