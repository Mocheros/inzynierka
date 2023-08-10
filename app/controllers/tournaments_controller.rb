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
    @tournament = Tournament.find(params[:id])
    @editors = @tournament.editors
    @tournament_editor = TournamentEditor.new
  end

  # POST /tournaments or /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)

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
      elsif tournament_params[:format] == "System pucharowy"
        Tournament.playoff_generator(teams, @tournament.id)
      end
      
      flash[:notice] = 'Turniej został utworzony pomyślnie'
      redirect_to tournament_url(@tournament)
    else
      if @tournament.name.blank?
        flash[:danger] = 'Nazwa nie może być pusta'
      elsif @tournament.format.blank?
        flash[:danger] = 'Wybierz format rozgrywek'
      elsif @tournament.number_of_teams.blank?
        flash[:danger] = 'Wybierz ilość drużyn'
      end
      redirect_to new_tournament_path
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Turniej został zaktualizowany pomyślnie'
      redirect_to edit_tournament_url(@tournament)
    else
      if @tournament.name.blank?
        flash[:danger] = 'Nazwa nie może być pusta'
        redirect_to edit_tournament_url(@tournament)
      end 
    end
  end

  # DELETE /tournaments/1 or /tournaments/1.json
  def destroy
    @tournament.destroy
  end

  def remove_editor
    @tournament = Tournament.find(params[:id])
    editor = User.find(params[:editor_id])
    if @tournament.editors.delete(editor)
      respond_to do |format|
        format.js {render inline: "location.reload();" }
      end
    end
  end

  def add_editor
    @tournament = Tournament.find(params[:id])
    @tournament_editor = TournamentEditor.new
  end
  
  def create_editor
    @tournament = Tournament.find(params[:id])
    @tournament_editor = TournamentEditor.new
    @tournament_editor.update(tournament_id: @tournament.id)
    user = User.find_by(email: editor_params[:email])

    if user.present?
      @tournament_editor.update(user_id: user.id)
      if @tournament_editor.save
        redirect_to edit_tournament_path(@tournament), notice: "Moderator został dodany"
      else
        flash[:danger] = 'Moderator nie został dodany'
        redirect_to edit_tournament_path(@tournament)
      end
    else
      flash[:danger] = 'Nie ma takiego użytkownika'
      redirect_to edit_tournament_path(@tournament)
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

    def editor_params
      params.require(:tournament_editor).permit(:email)
    end
end
