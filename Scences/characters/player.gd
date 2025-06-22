class_name Player
extends CharacterBody2D
enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING}
@export var speed : float
@export var control_scheme : ControlScheme
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var player_sprite : Sprite2D = %PlayerSprite
var current_state : PlayerState = null 
var state_factory := PlayerStateFactory.new()
var heading := Vector2.RIGHT
func _ready() -> void:
	switch_state(State.MOVING)
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	flip_sprite()
	move_and_slide()
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
	elif heading ==Vector2.LEFT:
		player_sprite.flip_h = true
func switch_state(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, animation_player)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine" + str(state)
	call_deferred("add_child", current_state)
