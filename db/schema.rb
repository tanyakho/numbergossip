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

ActiveRecord::Schema.define(version: 2022_03_12_194216) do

  create_table "knowledge_gaps", force: :cascade do |t|
    t.integer "property_id"
    t.text "number"
  end

  create_table "properties", force: :cascade do |t|
    t.string "adjective", limit: 100, default: "", null: false
    t.string "alternate_adjective", limit: 100
    t.string "plural_noun", limit: 200, default: "", null: false
    t.text "definition", null: false
    t.integer "manual_coolness"
    t.integer "manual_knowledge_bound"
    t.datetime "updated_at"
    t.datetime "occurrences_updated_at"
  end

  create_table "property_occurrences", force: :cascade do |t|
    t.text "number", null: false
    t.integer "property_id", default: 0, null: false
    t.index ["property_id"], name: "fk_occurrence_property"
  end

  create_table "unique_properties", force: :cascade do |t|
    t.integer "number", default: 0, null: false
    t.text "statement", null: false
    t.string "display", limit: 20, default: "", null: false
    t.string "interest", limit: 20, default: "", null: false
    t.string "truth", limit: 20, default: "", null: false
    t.string "uniqueness", limit: 20, default: "", null: false
    t.string "helper", limit: 50
    t.text "proof_credit"
    t.text "source"
    t.text "comments"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

end
