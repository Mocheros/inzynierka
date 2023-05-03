class SingleStatsController < ApplicationController

  # GET /single_stats or /single_stats.json
  def index
    @single_stats = SingleStat.all
  end

  # GET /single_stats/1 or /single_stats/1.json
  def show
  end

  # GET /single_stats/new
  def new
    @single_stat = SingleStat.new
    @players = Player.where(team_id: current_team.id).all.to_a.map{ |c| [c.name, c.id]}
    render :new, locals: { tournament: tournament, game: game, current_team: current_team }
  end

  # GET /single_stats/1/edit
  def edit
  end

  # POST /single_stats or /single_stats.json
  def create
    @players = Player.where(team_id: current_team.id).all.to_a.map{ |c| [c.name, c.id]}
    if params[:second_player].present?
      @single_stat = SingleStat.create(game_id: game.id, team_id: current_team.id, first_player_id: params[:first_player], second_player_id: params[:second_player], minute: params[:minute], stat_type: params[:stat_type])
    else
      @single_stat = SingleStat.create(game_id: game.id, team_id: current_team.id, first_player_id: params[:first_player], minute: params[:minute], stat_type: params[:stat_type])
    end

    if @single_stat.save
      redirect_to tournament_game_path(tournament, game), notice: "Single stat was successfully created."
    else
      render :new, locals: { tournament: tournament, game: game, current_team: current_team }
    end
  end

  # PATCH/PUT /single_stats/1 or /single_stats/1.json
  def update
    respond_to do |format|
      if @single_stat.update(single_stat_params)
        format.html { redirect_to single_stat_url(@single_stat), notice: "Single stat was successfully updated." }
        format.json { render :show, status: :ok, location: @single_stat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @single_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /single_stats/1 or /single_stats/1.json
  def destroy
    @single_stat.destroy

    respond_to do |format|
      format.html { redirect_to single_stats_url, notice: "Single stat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def game
      @game ||= Game.find(params[:game_id])
    end

    def tournament
      @tournament ||= Tournament.find(params[:tournament_id])
    end

    def current_team
      @current_team ||= Team.find(params[:team_id])
    end

    # Only allow a list of trusted parameters through.
    def single_stat_params
      params.require(:single_stat).permit(:game_id, :team_id, :player_id, :assistant_id, :minute, :stat_type)
    end
end
