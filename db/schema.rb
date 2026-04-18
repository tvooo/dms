# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_18_070905) do
  create_table "document_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "document_id", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id", "tag_id"], name: "index_document_tags_on_document_id_and_tag_id", unique: true
    t.index ["document_id"], name: "index_document_tags_on_document_id"
    t.index ["tag_id"], name: "index_document_tags_on_tag_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.integer "file_size"
    t.datetime "indexed_at"
    t.string "mime_type"
    t.datetime "mtime"
    t.string "path", null: false
    t.integer "status", default: 0, null: false
    t.text "text_content"
    t.integer "thumbnail_status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["content_hash"], name: "index_documents_on_content_hash"
    t.index ["path"], name: "index_documents_on_path", unique: true
    t.index ["status"], name: "index_documents_on_status"
    t.index ["thumbnail_status"], name: "index_documents_on_thumbnail_status"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "parent_id"
    t.datetime "updated_at", null: false
    t.index "LOWER(name), parent_id", name: "index_tags_on_lower_name_and_parent", unique: true
    t.index ["parent_id"], name: "index_tags_on_parent_id"
  end

  add_foreign_key "document_tags", "documents"
  add_foreign_key "document_tags", "tags"
  add_foreign_key "tags", "tags", column: "parent_id"
end
