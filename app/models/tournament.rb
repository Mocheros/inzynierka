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

    teams = teams_array.map(&:id).shuffle
    
    if teams.length > 1
      round_1 = Round.create(name: "Finał", tournament_id: t_id)
      if teams.length > 3
        round_2 = Round.create(name: "Półfinał", tournament_id: t_id)
        if teams.length > 7
          round_4 = Round.create(name: "Ćwierćfinał", tournament_id: t_id)
          if teams.length > 15
            round_8 = Round.create(name: "1/8-Finału", tournament_id: t_id)
            if teams.length > 31
              round_16 = Round.create(name: "1/16-Finału", tournament_id: t_id)
              if teams.length > 63
                round_32 = Round.create(name: "1/32-Finału", tournament_id: t_id)
                if teams.length > 127
                  round_128 = Round.create(name: "1/64-Finału", tournament_id: t_id)
                  if teams.length > 255
                    round_256 = Round.create(name: "1/128-Finału", tournament_id: t_id)
                  end
                end
              end
            end
          end
        end
      end
    end

    teams.shuffle.each_slice(2).with_index do |(team1, team2), index|
      if teams.length == 2
        game_of_1 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_1.id, tournament_id: t_id)
      elsif teams.length == 4
        game_of_2 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_2.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      elsif teams.length == 8
        game_of_4 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_4.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).second_to_last.id, round_id: round_2.id, tournament_id: t_id)
        end
        if (index + 1) % 4 == 0
          game_of_1 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      elsif teams.length == 16
        game_of_8 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_8.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_4 = Game.create(first_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).second_to_last.id, round_id: round_4.id, tournament_id: t_id)
        end
        if (index + 1) % 4 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).second_to_last.id, round_id: round_2.id, tournament_id: t_id)
        end
        if (index + 1) % 8 == 0
          game_of_1 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      elsif teams.length == 32
        game_of_16 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_16.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_8 = Game.create(first_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).second_to_last.id, round_id: round_8.id, tournament_id: t_id)
        end
        if (index + 1) % 4 == 0
          game_of_4 = Game.create(first_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).second_to_last.id, round_id: round_4.id, tournament_id: t_id)
        end
        if (index + 1) % 8 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).second_to_last.id, round_id: round_2.id, tournament_id: t_id)
        end
        if (index + 1) % 16 == 0
          game_of_1 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      elsif teams.length == 64
        game_of_32 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_32.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_16 = Game.create(first_previous_game_id: Game.where(round_id: round_32.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_32.id, tournament_id: t_id).second_to_last.id, round_id: round_16.id, tournament_id: t_id)
        end
        if (index + 1) % 4 == 0
          game_of_8 = Game.create(first_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).second_to_last.id, round_id: round_8.id, tournament_id: t_id)
        end
        if (index + 1) % 8 == 0
          game_of_4 = Game.create(first_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).second_to_last.id, round_id: round_4.id, tournament_id: t_id)
        end
        if (index + 1) % 16 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).second_to_last.id, round_id: round_2.id, tournament_id: t_id)
        end
        if (index + 1) % 32 == 0
          game_of_1 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      elsif teams.length == 128
        game_of_64 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_64.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_32 = Game.create(first_previous_game_id: Game.where(round_id: round_64.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_64.id, tournament_id: t_id).second_to_last.id, round_id: round_32.id, tournament_id: t_id)
        end
        if (index + 1) % 4 == 0
          game_of_16 = Game.create(first_previous_game_id: Game.where(round_id: round_32.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_32.id, tournament_id: t_id).second_to_last.id, round_id: round_16.id, tournament_id: t_id)
        end
        if (index + 1) % 8 == 0
          game_of_8 = Game.create(first_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).second_to_last.id, round_id: round_8.id, tournament_id: t_id)
        end
        if (index + 1) % 16 == 0
          game_of_4 = Game.create(first_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).second_to_last.id, round_id: round_4.id, tournament_id: t_id)
        end
        if (index + 1) % 32 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).second_to_last.id, round_id: round_2.id, tournament_id: t_id)
        end
        if (index + 1) % 64 == 0
          game_of_1 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      elsif teams.length == 256
        game_of_128 = Game.create(home_team_id: team1, away_team_id: team2, round_id: round_128.id, tournament_id: t_id)
        if (index + 1) % 2 == 0
          game_of_64 = Game.create(first_previous_game_id: Game.where(round_id: round_128.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_128.id, tournament_id: t_id).second_to_last.id, round_id: round_64.id, tournament_id: t_id)
        end
        if (index + 1) % 4 == 0
          game_of_32 = Game.create(first_previous_game_id: Game.where(round_id: round_64.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_64.id, tournament_id: t_id).second_to_last.id, round_id: round_32.id, tournament_id: t_id)
        end
        if (index + 1) % 8 == 0
          game_of_16 = Game.create(first_previous_game_id: Game.where(round_id: round_32.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_32.id, tournament_id: t_id).second_to_last.id, round_id: round_16.id, tournament_id: t_id)
        end
        if (index + 1) % 16 == 0
          game_of_8 = Game.create(first_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_16.id, tournament_id: t_id).second_to_last.id, round_id: round_8.id, tournament_id: t_id)
        end
        if (index + 1) % 32 == 0
          game_of_4 = Game.create(first_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_8.id, tournament_id: t_id).second_to_last.id, round_id: round_4.id, tournament_id: t_id)
        end
        if (index + 1) % 64 == 0
          game_of_2 = Game.create(first_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_4.id, tournament_id: t_id).second_to_last.id, round_id: round_2.id, tournament_id: t_id)
        end
        if (index + 1) % 128 == 0
          game_of_1 = Game.create(first_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).last.id, second_previous_game_id: Game.where(round_id: round_2.id, tournament_id: t_id).second_to_last.id, round_id: round_1.id, tournament_id: t_id)
        end
      end
    end


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
