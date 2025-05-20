class AlterTableRemoveOrderFromFolder < ActiveRecord::Migration[8.0]
  def change
    remove_column :folders, :order, :integer
  end
end
