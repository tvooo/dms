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

ActiveRecord::Schema[8.1].define(version: 2026_04_16_183705) do
  create_table "documents", force: :cascade do |t|
    t.string "content_hash"
    t.datetime "created_at", null: false
    t.integer "file_size"
    t.datetime "indexed_at"
    t.string "mime_type"
    t.string "path", null: false
    t.integer "status", default: 0, null: false
    t.text "text_content"
    t.datetime "updated_at", null: false
    t.index ["content_hash"], name: "index_documents_on_content_hash"
    t.index ["path"], name: "index_documents_on_path", unique: true
    t.index ["status"], name: "index_documents_on_status"
  end
end
