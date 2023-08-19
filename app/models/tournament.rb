class Tournament < ApplicationRecord
  before_create :generate_random_id

  has_many :teams
  has_many :rounds
  has_many :games

  has_many :tournament_editors, dependent: :destroy
  has_many :editors, through: :tournament_editors, source: :user


  validates :name, presence: true
  validates :format, presence: true
  validates :number_of_teams, presence: true


  def self.playoff_generator(teams_array, t_id)
    
  end

  def self.league_single_game_generator(teams_array, t_id)

    teams = teams_array.map(&:id).shuffle

    if teams.length.odd?
      teams << 0
    end

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
        game = Game.create(home_team_id: team1, away_team_id: team2, round_id: new_round.id, tournament_id: t_id)
        match = [team1, team2]
        round_matches << match
      end
      
      # Zamieniamy pozycje druzyn, by utworzyc nowa kolejke
      teams.insert(1, teams.pop)

      if teams.length.odd?
        bye_team = teams[0]
        round_matches << [bye_team, 0]
      end
    end
  end

  def self.league_double_game_generator(teams_array, t_id)

    teams = teams_array.map(&:id).shuffle

    if teams.length.odd?
      teams << 0
    end

    rounds = (teams.length - 1) * 2
    matches_per_round = teams.length / 2

    rounds.times do |round|
      new_round = Round.create!(name: "Kolejka nr #{round + 1}", tournament_id: t_id)

      teams.each_with_index do |team1, i|
        break if i >= teams.length / 2
        team2 = teams.reverse[i]
        next if team1 == team2
        # Dodajemy mecz do kolejki
        game = Game.create!(home_team_id: team1, away_team_id: team2, round_id: new_round.id, tournament_id: t_id)
      end
      
      # Zamieniamy pozycje druzyn, by utworzyc nowa kolejke
      teams.insert(1, teams.pop)

      if teams.length.odd?
        bye_team = teams[0]
      end
    end
  end

  private

  def generate_random_id
    self.id = SecureRandom.alphanumeric(6)
  end

end
