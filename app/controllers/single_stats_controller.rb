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
    position_order = {'Bramkarz' => 0, 'Obrońca' => 1, 'Pomocnik' => 2, 'Napastnik' => 3}
    @players = Player.where(team_id: current_team.id).order('name asc').all.to_a.sort_by { |player| position_order[player.position] }.map { |player| [player.name, player.id] }
    @team_events = SingleStat.where(game_id: game.id, team_id: current_team.id)
    render :new, locals: { tournament: tournament, game: game, current_team: current_team }
  end

  # GET /single_stats/1/edit
  def edit
    position_order = {'Bramkarz' => 0, 'Obrońca' => 1, 'Pomocnik' => 2, 'Napastnik' => 3}
    @players = Player.where(team_id: current_team.id).order('name asc').all.to_a.sort_by { |player| position_order[player.position] }.map { |player| [player.name, player.id] }
    @tournament = Tournament.find(params[:tournament_id])
    @game = Game.find(params[:game_id])
    @team = Team.find(params[:team_id])
    @single_stat = SingleStat.find(params[:id])
  end

  # POST /single_stats or /single_stats.json
  def create
    if params[:goal_first_player].blank? && params[:goal_second_player].blank? && params[:own_goal_player].blank? && params[:yellow_card_player].blank? && params[:red_card_player].blank? && params[:sub_on_player].blank? && params[:sub_off_player].blank? || (!params[:sub_on_player].blank? && params[:sub_off_player].blank?) || (params[:sub_on_player].blank? && !params[:sub_off_player].blank?) || (params[:goal_first_player].blank? && !params[:goal_second_player].blank?)
      flash[:error] = "Rodzaj wydarzenia i jego zawodnik nie mogą być puste"
      redirect_to new_tournament_game_team_single_stat_path(tournament, game, current_team)
      return
    end

    @players = Player.where(team_id: current_team.id).all.to_a.map{ |c| [c.name, c.id]}
    if params[:second_player].present?
      @single_stat = SingleStat.create(game_id: game.id, team_id: current_team.id, first_player_id: params[:first_player], second_player_id: params[:second_player], minute: params[:minute], stat_type: params[:stat_type])
    else
      @single_stat = SingleStat.create(game_id: game.id, team_id: current_team.id, first_player_id: params[:first_player], minute: params[:minute], stat_type: params[:stat_type])
    end

    if params[:stat_type] == "goal"
      @single_stat.first_player_id = params[:goal_first_player]
      Player.find(params[:goal_first_player]).increment!(:goals, 1)
      if params[:goal_second_player].present?
        @single_stat.second_player_id = params[:goal_second_player]
        Player.find(params[:goal_second_player]).increment!(:assists, 1)
      end
    elsif params[:stat_type] == "yellow_card"
      @single_stat.first_player_id = params[:yellow_card_player]
      Player.find(params[:yellow_card_player]).increment!(:yellow_cards, 1)
    elsif params[:stat_type] == "red_card"
      @single_stat.first_player_id = params[:red_card_player]
      Player.find(params[:red_card_player]).increment!(:red_cards, 1)
    elsif params[:stat_type] == "subs"
      @single_stat.first_player_id = params[:sub_on_player]
      @single_stat.second_player_id = params[:sub_off_player]
      Player.find(params[:sub_on_player]).increment!(:games_played, 1)
    elsif params[:stat_type] == "own_goal"
      @single_stat.first_player_id = params[:own_goal_player]
    end

    if @single_stat.save
      redirect_to tournament_game_path(tournament, game), notice: "Wydarzenie zostało utworzone"
    else
      flash[:error] = "Rodzaj wydarzenia i jego zawodnik nie mogą być puste"
      redirect_to new_tournament_game_team_single_stat_path(tournament, game, current_team)
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
    @tournament = Tournament.find(params[:tournament_id])
    @game = Game.find(params[:game_id])
    @team = Team.find(params[:team_id])
    @single_stat = SingleStat.find(params[:id])

    if @single_stat.delete
      if @single_stat.stat_type == "goal"
        Player.find(@single_stat.first_player_id).decrement!(:goals, 1)
        if @single_stat.second_player_id.present?
          Player.find(@single_stat.second_player_id).decrement!(:assists, 1)
        end
      elsif @single_stat.stat_type == "yellow_card"
        Player.find(@single_stat.first_player_id).decrement!(:yellow_cards, 1)
      elsif @single_stat.stat_type == "red_card"
        Player.find(@single_stat.first_player_id).decrement!(:red_cards, 1)
      elsif @single_stat.stat_type == "subs"
        Player.find(@single_stat.first_player_id).decrement!(:games_played, 1)
      end

      redirect_to new_tournament_game_team_single_stat_path(tournament, game, @single_stat.team_id), notice: "Wydarzenie zostało usunięte"
    else
      nil
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
