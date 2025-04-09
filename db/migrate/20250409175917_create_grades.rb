class CreateGrades < ActiveRecord::Migration[8.0]
  def change
    create_table :grades do |t|
      t.string :nom
      t.integer :seuil_min_points

      t.timestamps
    end
  end
end
