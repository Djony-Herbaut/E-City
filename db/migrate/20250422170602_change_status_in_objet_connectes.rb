class ChangeStatusInObjetConnectes < ActiveRecord::Migration[8.0]
  def change
    remove_column :objet_connectes, :status, :string if column_exists?(:objet_connectes, :status)

    add_column :objet_connectes, :status, :integer, default: 0
  end
end
