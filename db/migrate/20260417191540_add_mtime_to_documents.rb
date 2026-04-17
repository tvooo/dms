class AddMtimeToDocuments < ActiveRecord::Migration[8.1]
  def change
    add_column :documents, :mtime, :datetime
  end
end
