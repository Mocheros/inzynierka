class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized_to_edit_tournament

  private

  def user_not_authorized_to_edit_tournament
    flash[:danger] = 'Nie masz uprawnień do wykonania tej akcji.'
    redirect_to tournament_path(params[:id])
  end
end
