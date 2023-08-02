class ChangeGamesTableColumns < ActiveRecord::Migration[7.0]
  def change
    change_column_default :games, :home_score, nil
    change_column_default :games, :away_score, nil
    change_column_default :games, :status, "not_started"
    change_column_null :games, :home_score, true
    change_column_null :games, :away_score, true
  end
end
