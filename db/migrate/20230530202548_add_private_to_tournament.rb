class AddPrivateToTournament < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :private, :boolean, default: false, null: false
  end
end
