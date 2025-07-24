class_name SceenFactory
var screens: Dictionary


func _init() -> void:
	screens = {
		SoccerGame.SceenType.IN_GAME: preload("res://Scences/world.tscn"),
		SoccerGame.SceenType.MAIN_MENU: preload("res://Scences/UI/main_menu_screen.tscn"),
		SoccerGame.SceenType.TEAM_SELECTION: preload("res://Scences/UI/team_selection_screen.tscn"),
	}


func get_fresh_screen(screen: SoccerGame.SceenType) -> Screen:
	assert(screens.has(screen), "screen does not exist")
	return screens.get(screen).instantiate()
	
