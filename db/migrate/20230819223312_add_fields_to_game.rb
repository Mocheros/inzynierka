class AddFieldsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :first_previous_game_id, :integer
    add_column :games, :second_previous_game_id, :integer
  end
end
