# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_02_141224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "holidays", force: :cascade do |t|
    t.date "date"
    t.string "holidayable_type", null: false
    t.bigint "holidayable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["holidayable_type", "holidayable_id", "date"], name: "index_holidays_on_holidayable_type_and_holidayable_id_and_date", unique: true
    t.index ["holidayable_type", "holidayable_id"], name: "index_holidays_on_holidayable_type_and_holidayable_id"
  end

  create_table "territories", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_id"
    t.string "holidayable_type"
    t.bigint "holidayable_id"
    t.string "searchable_name", null: false
    t.string "kind", null: false
    t.integer "population", default: 0, null: false
    t.string "court", default: "0"
    t.index ["code"], name: "index_territories_on_code", unique: true
    t.index ["holidayable_type", "holidayable_id"], name: "index_territories_on_holidable"
    t.index ["kind"], name: "index_territories_on_kind"
    t.index ["parent_id"], name: "index_territories_on_parent_id"
  end

  add_foreign_key "territories", "territories", column: "parent_id"
end
