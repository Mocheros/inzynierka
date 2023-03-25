class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.string :position
      t.integer :shirt_number
      t.integer :games_played, null: false, default: 0
      t.integer :goals, null: false, default: 0
      t.integer :assists, null: false, default: 0
      t.integer :yellow_cards, null: false, default: 0
      t.integer :red_cards, null: false, default: 0
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
