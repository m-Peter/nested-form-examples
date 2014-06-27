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

ActiveRecord::Schema.define(version: 20140627120602) do

  create_table "conferences", force: true do |t|
    t.string   "name"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presentations", force: true do |t|
    t.string   "topic"
    t.string   "duration"
    t.integer  "speaker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presentations", ["speaker_id"], name: "index_presentations_on_speaker_id"

  create_table "speakers", force: true do |t|
    t.string   "name"
    t.string   "occupation"
    t.integer  "conference_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "speakers", ["conference_id"], name: "index_speakers_on_conference_id"

end
