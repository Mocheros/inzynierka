class AddTournamentIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :tournament_id, :string
    add_column :rounds, :tournament_id, :string
    add_column :games, :tournament_id, :string
  end
end
