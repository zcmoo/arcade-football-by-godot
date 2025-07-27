class_name Tournament
enum Stage {QUARTER_FINALS, SEMI_FINAL, FINAL, COMPLETE}
var current_stage: Stage = Stage.QUARTER_FINALS
var matchs = {
	Stage.QUARTER_FINALS: [],
	Stage.SEMI_FINAL: [],
	Stage.FINAL: [],
	Stage.COMPLETE: []
}
var winner = ""


func _init() -> void:
	var countries = DataLoadere.get_countries().slice(1, 9)
	countries.shuffle()
	create_bracket(Stage.QUARTER_FINALS, countries)

func create_bracket(stage: Stage, countries: Array[String]) -> void:
	for i in range(int(countries.size() / 2.0)):
		matchs[stage].append(Match.new(countries[i * 2], countries[i * 2 + 1]))

func advance() -> void:
	if current_stage < Stage.COMPLETE:
		var stage_mathes: Array = matchs[current_stage]
		var stage_winner: Array[String] = []
		for current_math : Match in stage_mathes:
			current_math.resolve()
			stage_winner.append(current_math.winner)
		current_stage = current_stage + 1 as Stage
		if current_stage == Stage.COMPLETE:
			winner = stage_winner[0]
		else:
			create_bracket(current_stage, stage_winner)
		
