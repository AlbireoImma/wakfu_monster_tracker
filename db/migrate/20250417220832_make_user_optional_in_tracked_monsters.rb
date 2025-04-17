class MakeUserOptionalInTrackedMonsters < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tracked_monsters, :user_id, true
  end
end
