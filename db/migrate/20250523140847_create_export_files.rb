class CreateExportFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :export_files do |t|
      t.references :folder, null: false, foreign_key: true
      t.string :filename
      t.decimal :size
      t.datetime :requested_at
      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :error_at
      t.string :error_message

      t.timestamps
    end
  end
end
