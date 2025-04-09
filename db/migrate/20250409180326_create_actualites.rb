class CreateActualites < ActiveRecord::Migration[8.0]
  def change
    create_table :actualites do |t|
      t.string :titre
      t.text :contenu
      t.string :image
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
