json.extract! tournament, :id, :name, :format, :number_of_teams, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
