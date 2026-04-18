class AddThumbnailStatusToDocuments < ActiveRecord::Migration[8.1]
  def change
    add_column :documents, :thumbnail_status, :integer, null: false, default: 0
    add_index :documents, :thumbnail_status
  end
end
