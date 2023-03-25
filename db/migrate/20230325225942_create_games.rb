class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :home_score, null: false, default: 0
      t.integer :away_score, null: false, default: 0
      t.string :location
      t.datetime :date
      t.string :status
      t.references :round, null: false, foreign_key: true

      t.timestamps
    end
  end
end
