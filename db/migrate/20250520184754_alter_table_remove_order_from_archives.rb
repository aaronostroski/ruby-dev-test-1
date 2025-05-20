class AlterTableRemoveOrderFromArchives < ActiveRecord::Migration[8.0]
  def change
    remove_column :archives, :order, :integer
  end
end
