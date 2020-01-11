class CreateActiveFires < ActiveRecord::Migration[5.2]
  def change
    create_table :active_fires do |t|
      t.column :json, :text
      t.column :country, :string

      t.timestamps
    end
  end
end
