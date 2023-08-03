class ChangeGamesTableColumn < ActiveRecord::Migration[7.0]
  def change
    change_column_default :games, :status, "upcoming"
  end
end
