# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_04_17_230619) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.integer "respawn_time"
    t.string "location"
    t.string "status"
    t.datetime "last_killed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "level"
    t.string "zone"
    t.string "region"
    t.text "tips"
  end

  create_table "tracked_monsters", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "monster_id", null: false
    t.datetime "next_spawn_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "anonymous_id"
    t.index ["monster_id"], name: "index_tracked_monsters_on_monster_id"
    t.index ["user_id"], name: "index_tracked_monsters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "tracked_monsters", "monsters"
  add_foreign_key "tracked_monsters", "users"
end
