json.extract! player, :id, :name, :shirt_number, :position, :goals, :assists, :yellow_cards, :red_cards, :games_played, :team_id, :created_at, :updated_at
json.url player_url(player, format: :json)
