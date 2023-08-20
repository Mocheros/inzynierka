class Game < ApplicationRecord
  belongs_to :round, optional: true
  belongs_to :home_team, class_name: 'Team', optional: true
  belongs_to :away_team, class_name: 'Team', optional: true
  belongs_to :first_previous_game, class_name: 'Game', optional: true
  belongs_to :second_previous_game, class_name: 'Game', optional: true

  has_many :single_stats
  has_many :lineups

  enum status: { upcoming: 'upcoming', live: 'live', finished: 'finished'}
end
