class ChangeStatusToIntegerInObjetConnectes < ActiveRecord::Migration[8.0]
  def change
    change_column :objet_connectes, :status, :integer, default: 0
  end
end
