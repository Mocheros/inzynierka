class TournamentEditor < ApplicationRecord
  belongs_to :user
  belongs_to :tournament

  attr_accessor :email

end