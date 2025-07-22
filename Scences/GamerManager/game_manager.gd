extends Node
enum State {IN_PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEROVER}
const DRATION_GAME_SEC = 2 * 60
const DURATION_IMPACT_PAUSE = 100
var time_left = 0.0
var contries: Array[String] = ["CHINA", "FRANCE"]
var player_setup: Array[String] = ["CHINA", ""]
var socre: Array[int] = [0, 0]
var state_factory = GameStateFactory.new()
var current_state: GameState = null
var time_since_pause = Time.get_ticks_msec()


func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS 

func _ready() -> void:
	time_left = DRATION_GAME_SEC
	GameEvents.impact_receive.connect(on_impact_received.bind())
	switch_state(State.RESET)

func _process(delta: float) -> void:
	if get_tree().paused and Time.get_ticks_msec() - time_since_pause > DURATION_IMPACT_PAUSE:
		get_tree().paused = false

func switch_state(state: State, data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, data)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "GameStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func is_coop() -> bool:
	return player_setup[0] == player_setup[1]

func is_single_player() -> bool:
	return player_setup[1].is_empty()

func is_game_tied() -> bool:
	return socre[0] == socre[1]

func get_winner_country() -> String:
	assert(not is_game_tied())
	return contries[0] if socre[0] > socre[1] else contries[1]

func increase_score(country_scored_on: String) -> void:
	var index_contry_scring = 1 if country_scored_on == contries[0] else 0
	socre[index_contry_scring] += 1
	GameEvents.score_changed.emit()

func on_impact_received(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		time_since_pause = Time.get_ticks_msec()
		get_tree().paused = true
	
	
	
