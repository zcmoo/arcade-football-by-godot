extends Node
signal team_reset
signal team_scored(country_scored_on: String)
signal kickoff_ready
signal kickoff_start
signal ball_possessed(player_name: String)
signal ball_released
signal score_changed
signal game_over(country_winner: String)
signal impact_receive(impact_position: Vector2, is_high_impact: bool)
