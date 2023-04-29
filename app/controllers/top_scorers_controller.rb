class TopScorersController < ApplicationController
  def index
    @top_scorers = Player.joins(:team).where(teams: {tournament_id: tournament.id}).order(goals: :desc, assists: :desc).distinct
  end

  private
  def tournament
    @tournament = Tournament.find(params[:tournament_id])
  end
end
