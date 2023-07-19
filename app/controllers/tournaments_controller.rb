class TournamentsController < ApplicationController
  before_action :set_tournament, only: %i[ show edit update destroy ]

  # GET /tournaments or /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1 or /tournaments/1.json
  def last_tournaments
  end

  def favorites
  end

  # GET /tournaments/new
  def new
    if current_user == nil
      redirect_to new_user_session_path
    end
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments or /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)

    respond_to do |format|
      if @tournament.save
        teams = []
        for a in 1..@tournament.number_of_teams do
          team = Team.create!(name: "Team ##{a}", tournament_id: @tournament.id)
          teams.push(team)
        end
        if tournament_params[:format] == "System ligowy"
          Tournament.league_single_game_generator(teams, @tournament.id)
        elsif tournament_params[:format] == "System ligowy z rewanżami"
          Tournament.league_double_game_generator(teams, @tournament.id)
        end
        format.html { redirect_to tournament_url(@tournament), notice: "Tournament was successfully created." }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to tournament_url(@tournament), notice: "Tournament was successfully updated." }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1 or /tournaments/1.json
  def destroy
    @tournament.destroy

    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: "Tournament was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tournament_params
      params.require(:tournament).permit(:name, :format, :number_of_teams, :private, :creator_id)
    end
end
