class AlterTableSizeOnArchives < ActiveRecord::Migration[8.0]
  def change
    change_column :archives, :size, :decimal, precision: 15, scale: 2
  end
end
