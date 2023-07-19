class AddFieldsToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :creator_id, :integer
  end
end
