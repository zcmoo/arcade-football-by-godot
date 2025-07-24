class_name SocreHelper


static func get_score_text(current_match: Match) -> String:
	return "%d - %d" % [current_match.goals_home, current_match.goals_away]

static func get_current_info(current_match: Match) -> String:
	if current_match.is_tied():
		return "TEAM ARE TIDE %d - %d" % [current_match.goals_home, current_match.goals_away]
	else:
		return "%s LEADS %s" % [current_match.winner, current_match.final_score]

static func get_finnal_score_info(current_match: Match) -> String:
	return "%s WINS %s" % [current_match.winner, current_match.final_score]
