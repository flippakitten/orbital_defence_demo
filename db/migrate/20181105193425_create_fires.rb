class CreateFires < ActiveRecord::Migration[5.2]
  def change
    create_table :fires do |t|
      t.float :latitude, precision: 10, scale: 6
      t.float :longitude, precision: 10, scale: 6
      t.float   :brightness
      t.float   :bright_t31
      t.float   :bright_ti5
      t.float   :bright_ti4
      t.float   :scan
      t.float   :track
      t.float   :frp
      t.integer :distance
      t.string  :scan_type
      t.string  :identifier, index: true, uniqueness: true
      t.string  :lat_long, index: true, uniqueness: false
      t.string  :satellite
      t.string  :confidence
      t.string  :version
      t.string  :day_night
      t.timestamp :detected_at, index: true, uniqueness: false
      t.timestamps
    end
  end
end
