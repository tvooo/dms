class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.references :parent, foreign_key: { to_table: :tags }, null: true, index: true
      t.string :name, null: false
      t.timestamps
    end

    add_index :tags, "LOWER(name), parent_id", unique: true, name: "index_tags_on_lower_name_and_parent"
  end
end
