class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments, id: :uuid do |t|
      t.string :name
      t.string :format
      t.integer :number_of_teams

      t.timestamps
    end
  end
end
