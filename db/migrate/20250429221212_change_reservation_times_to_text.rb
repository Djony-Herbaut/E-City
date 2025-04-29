class ChangeReservationTimesToText < ActiveRecord::Migration[8.0]
  def change
    change_column :reservations, :start_time, :text
    change_column :reservations, :end_time, :text
  end
end
