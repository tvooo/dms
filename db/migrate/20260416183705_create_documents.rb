class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.string :path, null: false
      t.string :content_hash
      t.text :text_content
      t.integer :status, null: false, default: 0
      t.datetime :indexed_at
      t.integer :file_size
      t.string :mime_type

      t.timestamps
    end

    add_index :documents, :path, unique: true
    add_index :documents, :content_hash
    add_index :documents, :status
  end
end
