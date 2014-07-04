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

ActiveRecord::Schema.define(version: 20140704154716) do

  create_table "pilots", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "call_sign"
    t.integer  "ship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pilots", ["call_sign"], name: "uix_pilots_call_sign", unique: true
  add_index "pilots", ["ship_id"], name: "index_pilots_on_ship_id"
  add_index "pilots", ["ship_id"], name: "ix_pilots_ships"

  create_table "ships", force: true do |t|
    t.string   "name"
    t.integer  "crew"
    t.boolean  "has_astromech"
    t.integer  "speed"
    t.text     "armament"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ships", ["name"], name: "uix_ships_name", unique: true

end
