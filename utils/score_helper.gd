class_name SocreHelper


static func get_score_text(score: Array[int]) -> String:
	return "%d - %d" % [score[0], score[1]]

static func get_current_info(countries: Array[String], score: Array[int]) -> String:
	if score[0] == score[1]:
		return "TEAM ARE TIDE %d - %d" % [score[0], score[1]]
	elif score[0] > score[1]:
		return "%s LEADS %d - %d" % [countries[0], score[0], score[1]]
	else:
		return "%s LEADS %d - %d" % [countries[1], score[1], score[0]]
