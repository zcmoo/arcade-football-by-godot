class_name UI
extends CanvasLayer
@onready var flag_texture: Array[TextureRect] = [%HomeFlagTexture, %AwayFlagTexture2]
@onready var score_lable: Label = %ScoreLable
@onready var player_lable: Label = %PlayerLable
@onready var time_lable: Label = %TimeLable2
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var goal_score_lable: Label = %GoalScoreLable
@onready var score_info_lable: Label = %ScoreInfoLabel
var last_ball_carried = ""


func _ready() -> void:
	update_score()
	update_flag()
	update_clock()
	player_lable.text = ""
	GameEvents.ball_possessed.connect(on_ball_possessed.bind())
	GameEvents.ball_released.connect(on_ball_released.bind())
	GameEvents.score_changed.connect(on_score_changed.bind())
	GameEvents.team_reset.connect(on_team_reset.bind())
	GameEvents.game_over.connect(on_game_over.bind())

func _process(delta: float) -> void:
	update_clock()

func update_score() -> void:
	score_lable.text = SocreHelper.get_score_text(GameManager.socre)

func update_flag() -> void:
	for i in flag_texture.size():
		flag_texture[i].texture = FlagHeleper.get_texture(GameManager.contries[i])

func update_clock() -> void:
	if GameManager.time_left < 0:
		time_lable.modulate = Color.YELLOW
	time_lable.text = TimeHelper.get_time_text(GameManager.time_left)

func on_ball_possessed(player_name: String) -> void:
	player_lable.text = player_name
	last_ball_carried = player_name

func on_ball_released() -> void:
	player_lable.text = ""

func on_score_changed() -> void:
	if GameManager.time_left > 0:
		goal_score_lable.text = "%s SCORED!" % [last_ball_carried]
		score_info_lable.text = SocreHelper.get_current_info(GameManager.contries, GameManager.socre)
		animation_player.play("goal_appear")
	update_score()

func on_team_reset() -> void:
	animation_player.play("goal_hide")

func on_game_over(_country_winner: String) -> void:
	score_info_lable.text = SocreHelper.get_finnal_score_info(GameManager.contries, GameManager.socre)
	animation_player.play("gameover")
