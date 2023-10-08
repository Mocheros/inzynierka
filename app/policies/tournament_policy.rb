# frozen_string_literal: true

class TournamentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def edit?
    user && user.id == record.creator_id
  end

end
