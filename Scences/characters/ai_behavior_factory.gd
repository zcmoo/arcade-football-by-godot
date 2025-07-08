class_name AiBehaviorFactory
var roles: Dictionary


func _init() -> void:
	roles = {
		Player.Role.GOALE: AiBehaviorGoalie,
		Player.Role.DEFNSE: AiBehaviorField,
		Player.Role.MIDFIELD: AiBehaviorField,
		Player.Role.OFFNSE: AiBehaviorField,
	}

func get_ai_behavior(role: Player.Role) -> AIBehavior:
	assert(roles.has(role), "role doesn't exist")
	return roles.get(role).new()
