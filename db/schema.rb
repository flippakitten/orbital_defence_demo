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

ActiveRecord::Schema.define(version: 2018_11_13_075520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fires", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.float "brightness"
    t.float "bright_t31"
    t.float "bright_ti5"
    t.float "bright_ti4"
    t.float "scan"
    t.float "track"
    t.float "frp"
    t.integer "distance"
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

  create_table "weather_readings", force: :cascade do |t|
    t.bigint "weather_stations_id"
    t.float "temprature"
    t.float "pressure"
    t.float "ground_level"
    t.integer "humidity"
    t.float "wind_speed"
    t.float "wind_direction"
    t.float "rain"
    t.integer "cloud"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weather_stations_id"], name: "index_weather_readings_on_weather_stations_id"
  end

  create_table "weather_stations", force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.integer "identifier"
    t.datetime "reading_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
