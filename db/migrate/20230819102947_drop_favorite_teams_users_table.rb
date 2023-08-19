class DropFavoriteTeamsUsersTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :favorite_teams_users
  end
end
