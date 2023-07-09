class StandingsController < ApplicationController

  def index
    @standings = Team.where(tournament_id: tournament_id)
    @teams = Team.all
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def tournament_id
    @tournament = Tournament.find(params[:tournament_id])
  end
end
