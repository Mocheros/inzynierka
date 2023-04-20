class Tournament < ApplicationRecord
  has_many :teams
  has_many :rounds
  has_many :games


  def self.league_single_game_generator(teams_array, t_id)
    teams = teams_array.shuffle
    rounds = teams.length - 1
    matches_per_round = teams.length / 2

    rounds.times do |round|
      new_round = Round.create(name: "Kolejka nr #{round + 1}", tournament_id: t_id)
      round_matches = []
      teams.each_with_index do |team1, i|
        break if i >= teams.length / 2
        team2 = teams.reverse[i]
        next if team1 == team2

        # Dodajemy mecz do kolejki
        game = Game.create(home_team_id: team1.id, away_team_id: team2.id, round_id: new_round.id, tournament_id: t_id)
        match = [team1, team2]
        round_matches << match
      end
      
      # Zamieniamy pozycje druzyn, by utworzyc nowa kolejke
      teams.insert(1, teams.pop)
    end
  end

end
