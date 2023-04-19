class AddTournamentIdToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :tournament_id, :integer
  end
end
