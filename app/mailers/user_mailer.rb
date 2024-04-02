class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def add_moderator(user_id, tournament)
    @user_id = user_id
    @creator = User.find(tournament.creator_id).email
    @url = "http://localhost:3000/tournaments/#{tournament.id}"
    mail(to: User.find(@user_id).email, subject: 'Tournament moderator')
  end
end