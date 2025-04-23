class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :category
      t.string :type
      t.string :name
      t.string :address
      t.integer :area
      t.string :neighborhood
      t.string :status
      t.float :latitude
      t.float :longitude
      t.string :transport_line
      t.string :transport_type

      t.timestamps
    end
  end
end
