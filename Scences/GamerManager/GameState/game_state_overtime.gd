class_name GameStateOvertime
extends GameState


func _enter_tree() -> void:
	GameEvents.team_scored.connect(on_team_score.bind())

func on_team_score(country_scored_on: String) -> void:
	manager.increase_score(country_scored_on)
	transition_state(GameManager.State.GAMEROVER)
