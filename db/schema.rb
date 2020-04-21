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

ActiveRecord::Schema.define(version: 2020_04_21_210956) do

  create_table "autonomous_communities", force: :cascade do |t|
    t.string "name"
    t.integer "country_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "holidayable_type"
    t.integer "holidayable_id"
    t.index ["country_id"], name: "index_autonomous_communities_on_country_id"
    t.index ["holidayable_type", "holidayable_id"], name: "index_autonomous_communities_on_holidable"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "holidayable_type"
    t.integer "holidayable_id"
    t.index ["holidayable_type", "holidayable_id"], name: "index_countries_on_holidable"
  end

  create_table "holidays", force: :cascade do |t|
    t.date "date"
    t.string "holidayable_type", null: false
    t.integer "holidayable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index "\"holidayable\", \"date\"", name: "index_holidays_on_holidayable_and_date", unique: true
    t.index ["holidayable_type", "holidayable_id"], name: "index_holidays_on_holidayable_type_and_holidayable_id"
  end

  create_table "municipalities", id: false, force: :cascade do |t|
    t.string "code", limit: 5
    t.string "name"
    t.integer "autonomous_community_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["autonomous_community_id"], name: "index_municipalities_on_autonomous_community_id"
    t.index ["code"], name: "index_municipalities_on_code", unique: true
  end

  add_foreign_key "autonomous_communities", "countries"
  add_foreign_key "municipalities", "autonomous_communities"
end
