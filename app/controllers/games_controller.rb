class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    @games = Game.all
    @tournament = Tournament.find(params[:tournament_id])
    @rounds = Round.includes(:games).where(tournament_id: @tournament)
  end

  # GET /games/1 or /games/1.json
  def show
    @game = Game.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])

    @home_lineups = Lineup.where(game_id: @game.id, team_id: @game.home_team_id, lineup_type: "starting")
    @home_goalkeeper = Lineup.find_by(game_id: @game.id, team_id: @game.home_team_id, lineup_type: "goalkeeper")
    @home_subs = Lineup.where(game_id: @game.id, team_id: @game.home_team_id, lineup_type: "substitute")
    
    @away_lineups = Lineup.where(game_id: @game.id, team_id: @game.away_team_id, lineup_type: "starting")
    @away_goalkeeper = Lineup.find_by(game_id: @game.id, team_id: @game.away_team_id, lineup_type: "goalkeeper")
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
        format.html { redirect_to tournament_game_path(@tournament, @game), notice: "Game was successfully created." }
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
    
    if @game.update(game_params)
      if game_params[:status] == "finished"
        home_goals = SingleStat.where(game_id: @game.id, team_id: @game.home_team_id, stat_type: "goal").count + SingleStat.where(game_id: @game.id, team_id: @game.away_team_id, stat_type: "own_goal").count
        away_goals = SingleStat.where(game_id: @game.id, team_id: @game.away_team_id, stat_type: "goal").count + SingleStat.where(game_id: @game.id, team_id: @game.home_team_id, stat_type: "own_goal").count
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
          away_goals.increment!(:points, 1)
        end
        
        
      end
      redirect_to tournament_game_path(@tournament, @game), notice: "Game was successfully updated."
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
