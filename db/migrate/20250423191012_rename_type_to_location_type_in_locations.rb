class RenameTypeToLocationTypeInLocations < ActiveRecord::Migration[8.0]
  def change
    rename_column :locations, :type, :location_type
  end
end
