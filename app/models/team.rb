class Team < ApplicationRecord
  has_many :players
  belongs_to :tournament

  validates :name, presence: true
  
end
