class_name KeyUtils
enum Action {LEFT, RIGHT, UP, DOWN, SHOOT, PASS, SELECT}
const ACTIONS_MAP : Dictionary = {
	Player.ControlScheme.P1 : {
		Action.LEFT: "p1_left",
		Action.RIGHT: "p1_right",
		Action.UP: "p1_up",
		Action.DOWN: "p1_down", 
		Action.SHOOT: "p1_shoot", 
		Action.PASS: "p1_pass", 
		Action.SELECT: "确定"
	},
	Player.ControlScheme.P2 : {
		Action.LEFT: "p2_left",
		Action.RIGHT: "p2_right",
		Action.UP: "p2_up",
		Action.DOWN: "p2_down", 
		Action.SHOOT: "p2_shoot", 
		Action.PASS: "p2_pass", 
	}
}


static func get_input_vector(scheme: Player.ControlScheme) -> Vector2:
	var map:Dictionary = ACTIONS_MAP[scheme]
	return	Input.get_vector(map[Action.LEFT], map[Action.RIGHT], map[Action.UP], map[Action.DOWN])

static func is_action_pressed(scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_pressed(ACTIONS_MAP[scheme][action])

static func is_action_just_pressed(scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_just_pressed(ACTIONS_MAP[scheme][action])

static func is_action_just_released(scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_just_released(ACTIONS_MAP[scheme][action])
