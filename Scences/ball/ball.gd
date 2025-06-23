class_name Ball
extends AnimatableBody2D
enum State {ARRIED, FREEFORM, SHOT}
var velocity := Vector2.ZERO
var state_factory := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null
@onready var player_detection_area : Area2D = %PlayerDetectionArea
@onready var animation_player : AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	switch_state(State.FREEFORM) # 初始化状态节点
func switch_state(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)	
	current_state.setup(self, player_detection_area, carrier, animation_player) #状态子节点所需依赖项(球的属性，播放器等)
	current_state.state_transition_requested.connect(switch_state.bind()) # 触发调用该方法的信号
	current_state.name = "BallStateMachine" + str(state) # 可视化
	call_deferred("add_child", current_state) # 将现在的状态子节点添加到父节点中
