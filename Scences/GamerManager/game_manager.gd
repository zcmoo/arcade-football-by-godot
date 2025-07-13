extends Node
enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEROVER}
const DRATION_GAME_SEC = 2 * 60
var time_left = 0.0
var contries: Array[String] = ["CHINA", "USA"]
var socre: Array[int] = [0, 0]
var state_factory = GameStateFactory.new()
var current_state: GameState = null


func _ready() -> void:
	time_left = DRATION_GAME_SEC
	switch_state(State.IN_PLAY)

func switch_state(state: State, data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, data)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "GameStateMachine: " + str(state)
	call_deferred("add_child", current_state)
