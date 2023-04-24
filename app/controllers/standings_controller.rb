class StandingsController < ApplicationController

  def index
    @standings = Team.where(tournament_id: tournament_id)
  end

  private
  def tournament_id
    @tournament = Tournament.find(params[:tournament_id])
  end
end
