class CreateSingleStats < ActiveRecord::Migration[7.0]
  def change
    create_table :single_stats do |t|
      t.integer :game_id
      t.integer :team_id
      t.integer :player_id
      t.integer :assistant_id
      t.integer :minute
      t.string :stat_type

      t.timestamps
    end
  end
end
