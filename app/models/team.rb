class Team < ApplicationRecord
  belongs_to :tournament
  has_many :players

  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user

  validates :name, presence: true
  
end
