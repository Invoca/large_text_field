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

ActiveRecord::Schema.define(version: 2025_06_04_150254) do

  create_table "dummy_large_text_fields", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "field_name", null: false
    t.text "value", size: :medium
    t.integer "owner_id", null: false
    t.string "owner_type", null: false
    t.index ["owner_type", "owner_id", "field_name"], name: "dummy_large_text_field_by_owner_field", unique: true
  end

  create_table "large_text_fields", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "field_name", null: false
    t.text "value", size: :medium
    t.integer "owner_id", null: false
    t.string "owner_type", null: false
    t.index ["owner_type", "owner_id", "field_name"], name: "large_text_field_by_owner_field", unique: true
  end

  create_table "libraries", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "people", charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
