class FavoriteTeamsUsersController < ApplicationController
  def toggle_favorite
    team = Team.find(params[:team_id])
    if current_user.favorite_teams.include?(team)
      current_user.favorite_teams.delete(team)
      favorite = false
    else
      current_user.favorite_teams << team
      favorite = true
    end
    render json: { favorite: favorite }, status: :ok
  end
end
