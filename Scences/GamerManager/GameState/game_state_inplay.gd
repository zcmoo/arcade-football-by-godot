class_name GameStateInplay
extends GameState


func _enter_tree() -> void:
	GameEvents.team_scored.connect(on_team_scored.bind())

func _process(delta: float) -> void:
	manager.time_left -= delta
	if manager.time_left <= 0:
		if manager.current_match.is_tied():
			transition_state(GameManager.State.OVERTIME)
		else:
			transition_state(GameManager.State.GAMEROVER)

func on_team_scored(country_scored_on: String) -> void:
	transition_state(GameManager.State.SCORED, GameStateData.build().set_country_scored_on(country_scored_on))
