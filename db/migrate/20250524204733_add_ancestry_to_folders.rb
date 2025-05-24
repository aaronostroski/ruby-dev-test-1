class AddAncestryToFolders < ActiveRecord::Migration[8.0]
  def change
    remove_column :folders, :parent_folder_id, :integer
    add_column :folders, :ancestry, :string, collation: 'C'
    add_index :folders, :ancestry
  end
end
