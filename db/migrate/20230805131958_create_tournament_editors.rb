class CreateTournamentEditors < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_editors do |t|
      t.string :tournament_id
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_foreign_key :tournament_editors, :tournaments, column: :tournament_id, primary_key: :id
  end
end
