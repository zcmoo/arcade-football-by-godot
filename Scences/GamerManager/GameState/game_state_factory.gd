class_name GameStateFactory
var states: Dictionary


func _init() -> void:
	states = {
		GameManager.State.IN_PLAY : GameStateInplay,
		GameManager.State.GAMEROVER : GameStateGameOver,
		GameManager.State.OVERTIME : GameStateOvertime,
		GameManager.State.RESET : GameStateReset,
		GameManager.State.SCORED : GameStaeScored,
		GameManager.State.KICKOFF: GameStateKickoff
	}

func get_fresh_state(state : GameManager.State) -> GameState:
	assert(states.has(state), "state does not exist")
	return states.get(state).new()
