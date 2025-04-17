class AddAnonymousIdToTrackedMonsters < ActiveRecord::Migration[7.1]
  def change
    add_column :tracked_monsters, :anonymous_id, :string
  end
end
