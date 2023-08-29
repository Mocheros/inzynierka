class LineupsController < ApplicationController
  before_action :check_permission, only: [:new]
  # GET /lineups or /lineups.json
  def index
    @lineups = Lineup.all
  end

  # GET /lineups/1 or /lineups/1.json
  def show
  end

  # GET /lineups/new
  def new
    if params[:format] == "subs"
      @starting_lineup ||= Player.joins(:lineups).where("lineups.game_id = ? AND lineups.team_id = ? AND lineups.lineup_type = ?", game.id, current_team.id, "starting")
      @all_team_players ||= Player.where(team_id: current_team.id)
      @possible_subs ||= @all_team_players - @starting_lineup
      @possible_subs = @possible_subs.sort_by { |sub_player| position_order[sub_player.position] }
    end
    @new_starting_lineup = Array.new(11) { Lineup.new }
    render :new, locals: { tournament: tournament, game: game, field_players: field_players, current_team: current_team }
  end

  # GET /lineups/1/edit
  def edit
  end

  # POST /lineups or /lineups.json
  def create

    if params[:field_players].present? && !params[:subs].present? && !Lineup.where(game_id: game.id, team_id: current_team.id, lineup_type: "starting").exists?
      starting_field_players = params[:field_players].values.pluck(:id).map do |starting_field_player|
        Lineup.create(game_id: game.id, player_id: starting_field_player, team_id: current_team.id, lineup_type: "starting")
        Player.find(starting_field_player).increment!(:games_played, 1)
      end

      if (starting_field_players.compact.all?(&:persisted?))
        redirect_to new_tournament_game_team_lineup_path(tournament, game, current_team.id, "subs"), notice: 'Skład wyjściowy dodany!'
      else
        redirect_to new_tournament_game_team_lineup_path(tournament, game, current_team.id, "starting")
      end

    elsif !params[:field_players].present? && params[:subs].present? && Lineup.where(game_id: game.id, team_id: current_team.id, lineup_type: "starting").exists?
      sub_players = params[:subs].values.pluck(:id).map do |sub_player|
        Lineup.create(game_id: game.id, player_id: sub_player, team_id: current_team.id, lineup_type: "substitute")
      end

      if (sub_players.compact.all?(&:persisted?))
        redirect_to tournament_game_path(tournament, game), notice: 'Ławka rezerwowych dodana!'
      else
        redirect_to new_tournament_game_team_lineup_path(tournament, game, current_team.id, "starting")
      end
    
    elsif Lineup.where(game_id: game.id, team_id: current_team.id, lineup_type: "starting").exists? && !params[:field_players].present? && !params[:subs].present?
      redirect_to tournament_game_path(tournament, game), notice: 'Ławka rezerwowych jest pusta'

    elsif !params[:field_players].present? && !Lineup.where(game_id: game.id, team_id: current_team.id, lineup_type: "starting").exists?
      flash[:error] = "Wybierz zawodników do składu!"
      redirect_to new_tournament_game_team_lineup_path(tournament, game, current_team.id, "starting")
    end
    
  end

  # PATCH/PUT /lineups/1 or /lineups/1.json
  def update
    respond_to do |format|
      if @lineup.update(lineup_params)
        format.html { redirect_to lineup_url(@lineup), notice: "Lineup was successfully updated." }
        format.json { render :show, status: :ok, location: @lineup }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lineup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lineups/1 or /lineups/1.json
  def destroy
    @game = Game.find(params[:game_id])
    @tournament = Tournament.find(params[:tournament_id])

    lineups = Lineup.where(game_id: @game.id, team_id: current_team.id)
    lineups.each do |lineup|
      if lineup.lineup_type == "starting"
        Player.find(lineup.player_id).decrement!(:games_played, 1)
      end
      lineup.destroy
    end
    redirect_to new_tournament_game_team_lineup_path(@tournament, @game, current_team.id, "starting"), notice: "Skład został usunięty"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def game
      @game ||= Game.find(params[:game_id])
    end

    def tournament
      @tournament ||= Tournament.find(params[:tournament_id])
    end

    def field_players
      @field_players ||= Player.where(team_id: current_team.id).order('name asc').sort_by { |player| position_order[player.position] }
    end

    def current_team
      @current_team ||= Team.find(params[:team_id])
    end

    def position_order
      position_order = {'Bramkarz' => 0, 'Obrońca' => 1, 'Pomocnik' => 2, 'Napastnik' => 3}
    end

    def check_permission
      if !current_user || (current_user.id != tournament.creator_id && !tournament.editors.include?(current_user))
        flash[:danger] = 'Nie masz uprawnień do wykonania tej akcji.'
        redirect_to tournament_path(tournament)
      end
    end

    # Only allow a list of trusted parameters through.
    def lineup_params
      params.require(:lineup).permit(:game_id, :player_id, :team_id, :lineup_type)
    end
end
