json.extract! single_stat, :id, :game_id, :team_id, :player_id, :assistant_id, :minute, :stat_type, :created_at, :updated_at
json.url single_stat_url(single_stat, format: :json)
