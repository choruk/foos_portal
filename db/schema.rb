# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190322185259) do

  create_table "games", force: true do |t|
    t.datetime "finished_at"
    t.boolean  "abandoned",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
  end

  create_table "meeting_room_directions", force: true do |t|
    t.string   "room_name",           null: false
    t.text     "direction",           null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image",               null: false
    t.string   "online_meeting_link"
  end

  create_table "results", force: true do |t|
    t.integer  "game_id",                    null: false
    t.integer  "user_id",                    null: false
    t.boolean  "win",        default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank"
    t.boolean  "ranked",     default: false, null: false
  end

  add_index "results", ["game_id"], name: "fk_results_game_id_games", using: :btree
  add_index "results", ["user_id"], name: "fk_results_user_id_users", using: :btree

  create_table "users", force: true do |t|
    t.string   "slack_user_id",                  null: false
    t.string   "slack_user_name",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rank",            default: 1500, null: false
  end

end
