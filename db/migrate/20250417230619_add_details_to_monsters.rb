class AddDetailsToMonsters < ActiveRecord::Migration[7.1]
  def change
    add_column :monsters, :level, :string
    add_column :monsters, :zone, :string
    add_column :monsters, :region, :string
    add_column :monsters, :tips, :text
  end
end
