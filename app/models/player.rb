class Player < ApplicationRecord
  belongs_to :team
  has_many :single_stats
  has_many :lineups
end
