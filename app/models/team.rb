class Team < ApplicationRecord
  has_many :players
  belongs_to :tournament
  has_many :favorite_teams_users, class_name: 'FavoriteTeamsUser', foreign_key: :team_id
  has_many :users, through: :favorite_teams_users
end
