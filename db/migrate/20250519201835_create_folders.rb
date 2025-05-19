class CreateFolders < ActiveRecord::Migration[8.0]
  def change
    create_table :folders do |t|
      t.references :parent_folder, foreign_key: { to_table: :folders }, index: true, null: true
      t.string :name, null: false
      t.string :description
      t.integer :order, null: false

      t.timestamps
    end
  end
end
