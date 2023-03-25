json.extract! team, :id, :name, :games_played, :wins, :draws, :defeats, :goals_for, :goals_against, :points, :created_at, :updated_at
json.url team_url(team, format: :json)
