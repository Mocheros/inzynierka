class TopScorersController < ApplicationController
  def index
    @top_scorers = Player.joins(:team).where(teams: {tournament_id: tournament.id}).where('goals > 0 OR assists > 0').order(goals: :desc, assists: :desc).distinct
  end

  private
  def tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
