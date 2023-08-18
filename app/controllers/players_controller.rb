class PlayersController < ApplicationController

  # GET /players or /players.json
  def index
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show
  end

  # GET /players/new
  def new
    @players = Array.new(20) { Player.new }
    render :new, locals: { tournament: tournament, team: team }
  end

  # GET /players/1/edit
  def edit
    @tournament = Tournament.find(params[:tournament_id])
    @team = Team.find(params[:team_id])
    @player = Player.find(params[:id])
  end

  # POST /players or /players.json
  def create
    @players = params[:players].values.pluck(:name, :shirt_number, :position).map do |player_params_loop|
      unless player_params_loop[0].empty?
        Player.create(name: player_params_loop[0], shirt_number: player_params_loop[1], position: player_params_loop[2], team_id: team.id)
      end
    end
    
    if @players.compact.all?(&:persisted?)
      flash[:notice] = 'Zawodnicy zostali dodani'
      redirect_to tournament_team_path(tournament, team)
    else
      flash[:danger] = 'Każdy z zawodników musi mieć przypisaną pozycje! Numery powinny być z zakresu 0-99'
      redirect_to new_tournament_team_player_path(tournament, team)
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    @tournament = Tournament.find(params[:tournament_id])
    @team = Team.find(params[:team_id])
    @player = Player.find(params[:id])

    if @player.update(player_params)
      flash[:notice] = 'Zawodnik został zaktualizowany'
      redirect_to tournament_team_path(@tournament, @team)
    else
      flash[:danger] = 'Zawodnik nie został zaktualizowany!'
      redirect_to edit_tournament_team_player_path(@tournament, @team)
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy

    respond_to do |format|
      format.html { redirect_to players_url, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def tournament
      @tournament ||= Tournament.find(params[:tournament_id])
    end

    def team
      @team ||= Team.find(params[:team_id])
    end

    def player
      @player ||= Player.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:name, :shirt_number, :position, :goals, :assists, :yellow_cards, :red_cards, :games_played, :team_id)
    end
end
