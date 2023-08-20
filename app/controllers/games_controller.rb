class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    @games = Game.all
    @tournament = Tournament.find(params[:tournament_id])
    if @tournament.format == "System pucharowy"
      @rounds = Round.includes(:games).where(tournament_id: @tournament).reverse
    else
      @rounds = Round.includes(:games).where(tournament_id: @tournament)
    end
  end

  # GET /games/1 or /games/1.json
  def show
    @game = Game.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])

    @home_lineups = Lineup.where(game_id: @game.id, team_id: @game.home_team_id, lineup_type: "starting")
    @home_subs = Lineup.where(game_id: @game.id, team_id: @game.home_team_id, lineup_type: "substitute")
    
    @away_lineups = Lineup.where(game_id: @game.id, team_id: @game.away_team_id, lineup_type: "starting")
    @away_subs = Lineup.where(game_id: @game.id, team_id: @game.away_team_id, lineup_type: "substitute")

    @game_events = SingleStat.where(game_id: @game.id).order(:minute)

    @home_goals = SingleStat.where(game_id: @game.id, team_id: @game.home_team_id, stat_type: "goal").count + SingleStat.where(game_id: @game.id, team_id: @game.away_team_id, stat_type: "own_goal").count
    @away_goals = SingleStat.where(game_id: @game.id, team_id: @game.away_team_id, stat_type: "goal").count + SingleStat.where(game_id: @game.id, team_id: @game.home_team_id, stat_type: "own_goal").count
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
    @tournaments_teams = Team.where(tournament_id: @tournament.id).order(:name)
    @tournaments_rounds = Round.where(tournament_id: @tournament.id).order(:name)
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to tournament_game_path(@tournament, @game)}
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    @game = Game.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
    home_goals = SingleStat.where(game_id: @game.id, team_id: @game.home_team_id, stat_type: "goal").count + SingleStat.where(game_id: @game.id, team_id: @game.away_team_id, stat_type: "own_goal").count
    away_goals = SingleStat.where(game_id: @game.id, team_id: @game.away_team_id, stat_type: "goal").count + SingleStat.where(game_id: @game.id, team_id: @game.home_team_id, stat_type: "own_goal").count

    if @tournament.format == "System pucharowy" && game_params[:status] == "finished" && home_goals == away_goals
      flash[:danger] = 'Mecz pucharowy nie może zakończyć się remisem!'
      redirect_to edit_tournament_game_path(@tournament, @game)
      return
    end
    
    if @game.update(game_params)
      if game_params[:status] == "finished"
        @game.update(home_score: home_goals, away_score: away_goals)
        
        home_team = Team.find_by(id: @game.home_team_id)
        away_team = Team.find_by(id: @game.away_team_id)

        home_team.increment!(:games_played, 1)
        away_team.increment!(:games_played, 1)
        
        home_team.increment!(:goals_for, home_goals)
        home_team.increment!(:goals_against, away_goals)
        away_team.increment!(:goals_for, away_goals)
        away_team.increment!(:goals_against, home_goals)

        if home_goals > away_goals
          home_team.increment!(:wins, 1)
          home_team.update(points: home_team.points + 3)
          away_team.increment!(:defeats, 1)
        elsif home_goals < away_goals
          away_team.increment!(:wins, 1)
          away_team.update(points: away_team.points + 3)
          home_team.increment!(:defeats, 1)
        else
          home_team.increment!(:draws, 1)
          home_team.increment!(:points, 1)
          away_team.increment!(:draws, 1)
          away_team.increment!(:points, 1)
        end

        if @tournament.format == "System pucharowy"
          if home_goals > away_goals
            game_winner = home_team
          elsif home_goals < away_goals
            game_winner = away_team
          end

          next_game_home = Game.find_by("first_previous_game_id = ?", @game.id)
          next_game_away = Game.find_by("second_previous_game_id = ?", @game.id)

          if next_game_home
            next_game_home.update(home_team_id: game_winner.id)
          end

          if next_game_away
            next_game_away.update(away_team_id: game_winner.id)
          end
        end
      end
      redirect_to tournament_game_path(@tournament, @game), notice: "Mecz został zaktualizowany"
    # else
    #   format.html { render :edit, status: :unprocessable_entity }
    #   format.json { render json: @game.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:home_team_id, :away_team_id, :home_score, :away_score, :location, :date, :status, :round_id)
    end

    def tournament
      @tournament = Tournament.find(params[:tournament_id])
    end
end
