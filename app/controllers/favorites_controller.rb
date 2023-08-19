class FavoritesController < ApplicationController
  # before_action :authenticate_user!

  def new
    @favorite = Favorite.new
  end
  
  def create
    @favorite = Favorite.create(user_id: current_user.id, team_id: params[:team_id])
    if @favorite.save
      flash[:notice] = "Dodano drużynę do ulubionych!"
      redirect_to tournament_team_path(params[:tournament_id], params[:team_id])
    end
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, team_id: params[:team_id])
    if @favorite.destroy
      respond_to do |format|
        format.js {render inline: "location.reload();" }
      end
    end
  end

end
