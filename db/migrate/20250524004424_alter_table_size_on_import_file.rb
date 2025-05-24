class AlterTableSizeOnImportFile < ActiveRecord::Migration[8.0]
  def change
    change_column :export_files, :size, :decimal, precision: 15, scale: 2
  end
end
