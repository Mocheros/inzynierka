class Game < ApplicationRecord
  belongs_to :round
  belongs_to :home_team , class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team , class_name: 'Team', foreign_key: 'away_team_id'

  has_many :single_stats

  enum status: { upcoming: 'upcoming', live: 'live', finished: 'finished'}
end
