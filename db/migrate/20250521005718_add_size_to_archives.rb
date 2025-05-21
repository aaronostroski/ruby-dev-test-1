class AddSizeToArchives < ActiveRecord::Migration[8.0]
  def change
    add_column :archives, :size, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
