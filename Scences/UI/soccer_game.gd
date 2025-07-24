class_name SoccerGame
extends Node
enum SceenType {MAIN_MENU, TEAM_SELECTION, TOURNAMENT, IN_GAME}
var current_screen: Screen = null
var screen_factory = SceenFactory.new()


func _init() -> void:
	switch_screen(SceenType.MAIN_MENU)

func switch_screen(screen: SceenType, data: ScreenData = ScreenData.new()) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_factory.get_fresh_screen(screen)
	current_screen.set_up(self, data)
	current_screen.Screen_transition_requested.connect(switch_screen.bind())
	call_deferred("add_child", current_screen)
