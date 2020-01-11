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

ActiveRecord::Schema.define(version: 2020_01_11_095208) do

  create_table "active_fires", id: :bigint, default: -> { "unique_rowid()" }, force: :cascade do |t|
    t.text "json"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fires", id: :bigint, default: -> { "unique_rowid()" }, force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.float "brightness"
    t.float "bright_t31"
    t.float "bright_ti5"
    t.float "bright_ti4"
    t.float "scan"
    t.float "track"
    t.float "frp"
    t.bigint "distance"
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
    t.bigint "weather_reading_id"
    t.index ["detected_at"], name: "index_fires_on_detected_at"
    t.index ["identifier"], name: "index_fires_on_identifier"
    t.index ["lat_long"], name: "index_fires_on_lat_long"
  end

  create_table "weather_readings", id: :bigint, default: -> { "unique_rowid()" }, force: :cascade do |t|
    t.bigint "weather_station_id"
    t.string "identifier"
    t.float "temprature"
    t.float "pressure"
    t.float "ground_level"
    t.bigint "humidity"
    t.float "wind_speed"
    t.float "wind_direction"
    t.float "rain"
    t.bigint "cloud"
    t.string "description"
    t.datetime "reading_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_weather_readings_on_identifier"
    t.index ["weather_station_id"], name: "index_weather_readings_on_weather_station_id"
  end

  create_table "weather_stations", id: :bigint, default: -> { "unique_rowid()" }, force: :cascade do |t|
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_weather_stations_on_identifier"
  end

end
