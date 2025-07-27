class_name World
extends Screen
@onready var game_over_timer = %GameOverTimer


func _ready() -> void:
	game_over_timer.timeout.connect(on_transition.bind())
	GameEvents.game_over.connect(on_game_over.bind())
	GameManager.start_game()

func on_game_over(winner: String) -> void:
	game_over_timer.start()

func on_transition() -> void:
	if (screen_data.tournament != null and GameManager.current_match.winner == GameManager.player_setup[0]) or (screen_data.tournament.current_stage == Tournament.Stage.FINAL):
		screen_data.tournament.advance()
		transition_screen(SoccerGame.SceenType.TOURNAMENT, screen_data)
	else:
		transition_screen(SoccerGame.SceenType.MAIN_MENU)
