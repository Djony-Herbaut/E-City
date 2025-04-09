class AddInfosToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :telephone, :string
    add_column :users, :foyer, :integer
    add_column :users, :grade_id, :integer
  end
end
