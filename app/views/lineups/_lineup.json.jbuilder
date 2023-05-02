json.extract! lineup, :id, :game_id, :player_id, :team_id, :type, :created_at, :updated_at
json.url lineup_url(lineup, format: :json)
