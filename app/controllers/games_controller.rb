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
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @tournament = Tournament.find(params[:tournament_id])
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
    
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to tournament_game_path(@tournament, @game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
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
