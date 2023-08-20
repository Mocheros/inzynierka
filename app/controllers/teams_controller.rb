class TeamsController < ApplicationController

  # GET /teams or /teams.json
  def index
    @tournament = Tournament.find(params['tournament_id'])
    @teams = Team.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /teams/1 or /teams/1.json
  def show
    @team = Team.find(params[:id])
    @tournament = Tournament.find(params['tournament_id'])
    position_order = {'Bramkarz' => 0,'Obrońca' => 1,'Pomocnik' => 2,'Napastnik' => 3}
    @players = Player.where(team_id: team.id).order('name asc').sort_by { |p| position_order[p.position] }
    @favorite = Favorite.new
    if current_user
      @has_favorite = Favorite.where(user_id: current_user.id, team_id: @team.id).exists?
    end
    end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
    @tournament = Tournament.find(params['tournament_id'])
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to team_url(@team), notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    @team = Team.find(params[:id])
    @tournament = Tournament.find(params['tournament_id'])
    if @team.update(team_params_name)
      flash[:notice] = 'Drużyna została zaktualizowana'
      redirect_to tournament_team_path(@tournament, @team)
    else
      flash[:danger] = 'Nazwa nie może być pusta'
      redirect_to edit_tournament_team_path(@tournament, @team)
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :games_played, :wins, :draws, :defeats, :goals_for, :goals_against, :points)
    end

    def team_params_name
      params.require(:team).permit(:name)
    end
end
