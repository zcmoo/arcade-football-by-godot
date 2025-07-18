class_name GameStateKickoff
extends GameState
var valid_control_schemes = []

func _enter_tree() -> void:
	var country_starting = state_data.country_scored_on
	if country_starting.is_empty():
		country_starting = manager.contries[0]
	if country_starting == manager.player_setup[0]:
		valid_control_schemes.append(Player.ControlScheme.P1)
	if country_starting == manager.player_setup[1]:
		valid_control_schemes.append(Player.ControlScheme.P2)
	if valid_control_schemes.size() == 0:
		valid_control_schemes.append(Player.ControlScheme.P1)

func _process(delta: float) -> void:
	for control_scheme: Player.ControlScheme in valid_control_schemes:
		if KeyUtils.is_action_just_pressed(control_scheme, KeyUtils.Action.PASS):
			GameEvents.kickoff_start.emit()
			transition_state(GameManager.State.IN_PLAY)
