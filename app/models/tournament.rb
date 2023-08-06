class Tournament < ApplicationRecord
  before_create :generate_random_id

  has_many :teams
  has_many :rounds
  has_many :games

  has_many :tournament_editors, dependent: :destroy
  has_many :editors, through: :tournament_editors, source: :user


  validates :format, presence: true
  validates :number_of_teams, presence: true


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

    # games = Game.where(tournament_id: t_id, round_id: nil)
    # games.shuffle.each do |game|
      

    #   # assigned_round_ids = Game.where.not(round_id: nil).where(tournament_id: t_id).where("home_team_id != #{game.home_team_id} OR away_team_id != #{game.home_team_id} OR home_team_id != #{game.away_team_id} OR away_team_id != #{game.away_team_id}").pluck(:round_id) # znajdź kolejki z tego turnieju, w których grała już wybrana drużyna - game 
    #   # assigned_round_ids = Game.where(tournament_id: t_id).where("home_team_id != #{game.home_team_id} OR away_team_id != #{game.home_team_id} OR home_team_id != #{game.away_team_id} OR away_team_id != #{game.away_team_id}").group(:round_id).having("count(round_id) != #{matches_per_round}").pluck(:round_id)
    #   assigned_round_ids = Game.includes(:round).where(tournament_id: t_id).where("home_team_id != #{game.home_team_id} OR away_team_id != #{game.home_team_id} OR home_team_id != #{game.away_team_id} OR away_team_id != #{game.away_team_id}").group(:round_id).having("count(round_id) = #{matches_per_round}").pluck(:round_id)

    #   forbidden_rounds = Game.joins(:round).group(:round_id).having("count(games.id) = #{matches_per_round}").where(tournament_id: t_id).where("home_team_id = #{game.home_team_id} OR away_team_id = #{game.home_team_id} OR home_team_id = #{game.away_team_id} OR away_team_id = #{game.away_team_id}").pluck(:round_id)

    #   xdd = forbidden_rounds.group(:round_id).having("count(round_id) = #{matches_per_round}").pluck(:round_id)

    #   free_rounds = Round.where(tournament_id: t_id).group(:id).having("count(id) = #{matches_per_round}").pluck(:id) 

    #   # kolejki w których nie ma jeszcze 2 meczów - kolejki w których ktoś ze sprawdzanego meczu (game) gra już w którymś meczu w tej kolejce



    #   incomplete_round_ids = Round.where(tournament_id: t_id).where.not(id: Round.joins(:games).group("rounds.id").having("count(games.id) = #{matches_per_round}").pluck(:id)).order(Arel.sql('RANDOM()')).pluck(:id) # rundy do których można przypisać jeszcze mecz

    #   full_rounds = Round.joins(:games).where(tournament_id: t_id).group('rounds.id').having("COUNT(games.id) = #{matches_per_round}").pluck(:id) #Rundy z full meczami

    #   random_round = (incomplete_round_ids - assigned_round_ids).sample






    #   game.update(round_id: random_round)
    #   game.save
    # end
    rounds = Round.includes(:games).where(tournament_id: t_id).group('rounds.id').having("COUNT(games.id) != #{matches_per_round}").pluck(:id)
    # rounds.each do |round|
    #   all_games = Game.where(tournament_id: t_id, round_id: nil)
    #   all_games.shuffle.each do |game|
    #     teams = [game.home_team, game.away_team]
    #     played_games = Round.find(round).games.where.not(id: game.id)
    #     available_rounds = Round.where(tournament_id: t_id).where.not(id: played_games.pluck(:round_id)).where('id IN (SELECT round_id FROM games WHERE team_id IN (?) AND round_id IN (?))', teams.map(&:id), Round.pluck(:id))
    #   end
    # end
  end

  private

  def generate_random_id
    self.id = SecureRandom.alphanumeric(6)
  end

end
