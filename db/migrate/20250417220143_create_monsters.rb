class CreateMonsters < ActiveRecord::Migration[7.1]
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :respawn_time
      t.string :location
      t.string :status
      t.datetime :last_killed_at

      t.timestamps
    end
  end
end
