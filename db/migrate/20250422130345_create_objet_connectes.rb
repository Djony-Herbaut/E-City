class CreateObjetConnectes < ActiveRecord::Migration[8.0]
  def change
    create_table :objet_connectes do |t|
      t.string :titre
      t.text :description
      t.string :image
      t.references :user, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
