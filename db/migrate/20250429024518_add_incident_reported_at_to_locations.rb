class AddIncidentReportedAtToLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :incident_reported_at, :datetime
  end
end
