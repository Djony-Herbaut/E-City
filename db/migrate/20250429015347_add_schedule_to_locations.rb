class AddScheduleToLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :schedule, :datetime
  end
end
