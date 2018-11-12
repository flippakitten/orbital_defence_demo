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

ActiveRecord::Schema.define(version: 2018_11_05_193425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fires", force: :cascade do |t|
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.float "brightness"
    t.float "bright_t31"
    t.float "bright_ti5"
    t.float "bright_ti4"
    t.float "scan"
    t.float "track"
    t.float "frp"
    t.string "scan_type"
    t.string "identifier"
    t.string "lat_long"
    t.string "satellite"
    t.string "confidence"
    t.string "version"
    t.string "day_night"
    t.datetime "detected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["detected_at"], name: "index_fires_on_detected_at"
    t.index ["identifier"], name: "index_fires_on_identifier"
    t.index ["lat_long"], name: "index_fires_on_lat_long"
  end

end
