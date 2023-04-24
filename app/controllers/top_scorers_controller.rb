class TopScorersController < ApplicationController
  def index
    @top_scorers = Player.joins(:teams).where(teams: {tournament_id: tournament_id}).distinct
  end

  private
  def tournament_id
    @tournament = Tournament.find(params[:tournament_id])
  end
end
