class ChangeTournamentIdType < ActiveRecord::Migration[7.0]
  def up
    change_column :tournaments, :id, :string, limit: 6
  end

  def down
    change_column :tournaments, :id, :uuid, default: -> { "gen_random_uuid()" }, force: :cascade
  end
end
