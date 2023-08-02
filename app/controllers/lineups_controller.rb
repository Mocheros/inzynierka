class LineupsController < ApplicationController
  before_action :set_lineup, only: %i[ show edit update destroy ]

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
      @starting_lineup ||= Player.joins(:lineups).where("lineups.game_id = ? AND lineups.team_id = ? AND lineups.lineup_type = ? OR lineups.lineup_type = ?", game.id, current_team.id, "starting", "goalkeeper")
      @all_team_players ||= Player.where(team_id: current_team.id)
      @possible_subs ||= @all_team_players - @starting_lineup
      @possible_subs = @possible_subs.sort_by { |sub_player| position_order[sub_player.position] }
    end
    @new_starting_lineup = Array.new(11) { Lineup.new }
    render :new, locals: { tournament: tournament, game: game, goalkeepers: goalkeepers, field_players: field_players, current_team: current_team }
  end

  # GET /lineups/1/edit
  def edit
  end

  # POST /lineups or /lineups.json
  def create
    if params[:goalkeeper_id].present?
      goalkeeper = Player.find_by(id: params[:goalkeeper_id])
      Lineup.create(game_id: game.id, player_id: goalkeeper.id, team_id: current_team.id, lineup_type: "goalkeeper")
      Player.find(params[:goalkeeper_id]).increment!(:games_played, 1)
      starting_field_players = params[:field_players].values.pluck(:id).map do |starting_field_player|
        Lineup.create(game_id: game.id, player_id: starting_field_player, team_id: current_team.id, lineup_type: "starting")
        Player.find(starting_field_player).increment!(:games_played, 1)
      end

      if (goalkeeper.save && starting_field_players.compact.all?(&:persisted?))
        redirect_to new_tournament_game_team_lineup_path(tournament, game, current_team.id, "subs"), notice: 'Lineup was successfully created.'
      else
        render :new, locals: { tournament: tournament, game: game, goalkeepers: goalkeepers, field_players: field_players, current_team: current_team }, status: :unprocessable_entity
      end

    else
      sub_players = params[:subs].values.pluck(:id).map do |sub_player|
        Lineup.create(game_id: game.id, player_id: sub_player, team_id: current_team.id, lineup_type: "substitute")
      end

      if (sub_players.compact.all?(&:persisted?))
        redirect_to tournament_game_path(tournament, game), notice: 'Lineup was successfully created.'
      else
        render :new, locals: { tournament: tournament, game: game, goalkeepers: goalkeepers, field_players: field_players, current_team: current_team }, status: :unprocessable_entity
      end
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
    @lineup.destroy

    respond_to do |format|
      format.html { redirect_to lineups_url, notice: "Lineup was successfully destroyed." }
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

    def goalkeepers
      @goalkeepers ||= Player.where(team_id: current_team.id, position: "Bramkarz").order('name asc')
    end

    def field_players
      @field_players ||= Player.where(team_id: current_team.id).where.not(position: 'Bramkarz').order('name asc').sort_by { |player| position_order[player.position] }
    end

    def current_team
      @current_team ||= Team.find(params[:team_id])
    end

    def position_order
      position_order = {'Bramkarz' => 0, 'Obrońca' => 1, 'Pomocnik' => 2, 'Napastnik' => 3}
    end

    # Only allow a list of trusted parameters through.
    def lineup_params
      params.require(:lineup).permit(:game_id, :player_id, :team_id, :lineup_type)
    end
end
