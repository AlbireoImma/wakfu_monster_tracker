class CreateTrackedMonsters < ActiveRecord::Migration[7.1]
  def change
    create_table :tracked_monsters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :monster, null: false, foreign_key: true
      t.datetime :next_spawn_time

      t.timestamps
    end
  end
end
