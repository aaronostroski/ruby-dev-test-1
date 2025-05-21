class AlterTableAddContentTypeToArchives < ActiveRecord::Migration[8.0]
  def change
    add_column :archives, :content_type, :string
  end
end
