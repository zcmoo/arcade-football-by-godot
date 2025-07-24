class_name MainMenuScreen
extends Screen
const MENU_TEXTURE = [
	[preload("res://assets/art/ui/mainmenu/1-player.png"),preload("res://assets/art/ui/mainmenu/1-player-selected.png")],
	[preload("res://assets/art/ui/mainmenu/2-players.png"),preload("res://assets/art/ui/mainmenu/2-players-selected.png")],
]
@onready var selection_menu_nodes: Array[TextureRect] = [%SinglePlayerRect, %TwoPlayerRect]
@onready var selection_icon = %SelectRect
var current_selection_index = 0
var is_active = false

func _ready() -> void:
	refresh_ui()

func _process(delta: float) -> void:
	if is_active:
		if KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.UP):
			change_selected_index(current_selection_index - 1)
		elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.DOWN):
			change_selected_index(current_selection_index + 1)
		elif KeyUtils.is_action_just_pressed(Player.ControlScheme.P1, KeyUtils.Action.SELECT):
			submit_selection()

func refresh_ui() -> void:
	for i in range(selection_menu_nodes.size()):
		if current_selection_index == i:
			selection_menu_nodes[i].texture = MENU_TEXTURE[i][1]
			selection_icon.position = selection_menu_nodes[i].position + Vector2.LEFT * 25
		else:
			selection_menu_nodes[i].texture = MENU_TEXTURE[i][0]

func change_selected_index(new_index) -> void:
	current_selection_index = clamp(new_index, 0, selection_menu_nodes.size() -1)
	SoundPlayer.play(SoundPlayer.Sound.UI_NAV)
	refresh_ui()

func submit_selection() -> void:
	SoundPlayer.play(SoundPlayer.Sound.UI_SELECT)
	var country_default = DataLoadere.get_countries()[4]
	var player_two = "" if current_selection_index == 0 else country_default
	GameManager.player_setup = [country_default, player_two]
	transition_screen(SoccerGame.SceenType.TEAM_SELECTION)

func on_set_active() -> void:
	refresh_ui()
	is_active = true	
