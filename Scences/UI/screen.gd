class_name Screen
extends Node
signal Screen_transition_requested(new_screen: SoccerGame.SceenType, data: ScreenData)
var game: SoccerGame = null
var screen_data: ScreenData = null
@export var music: MusicPlay.Music


func _enter_tree() -> void:
	MusicPlay.play_music(music)

func set_up(context_game: SoccerGame, context_data: ScreenData) -> void:
	game = context_game
	screen_data = context_data

func transition_screen(new_screen: SoccerGame.SceenType, data: ScreenData = ScreenData.new()):
	Screen_transition_requested.emit(new_screen, data)
