class FavoriteTeamsUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :favorite_teams_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :team
    end
  end
end
