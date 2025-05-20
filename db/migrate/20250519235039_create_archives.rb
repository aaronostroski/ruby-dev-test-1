class CreateArchives < ActiveRecord::Migration[8.0]
  def change
    create_table :archives do |t|
      t.references :folder, null: true, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.integer :order, null: false

      t.timestamps
    end
  end
end
