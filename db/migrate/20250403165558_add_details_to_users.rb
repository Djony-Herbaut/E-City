class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nom, :string
    add_column :users, :prenom, :string
    add_column :users, :points, :integer
  end
end
