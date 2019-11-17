# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 4) do

  create_table "knowledge_gaps", :force => true do |t|
    t.integer "property_id"
    t.text    "number"
  end

  create_table "properties", :force => true do |t|
    t.string   "adjective",              :limit => 100, :default => "", :null => false
    t.string   "alternate_adjective",    :limit => 100
    t.string   "plural_noun",            :limit => 200, :default => "", :null => false
    t.text     "definition",                                            :null => false
    t.integer  "manual_coolness"
    t.integer  "manual_knowledge_bound"
    t.datetime "updated_at"
    t.datetime "occurrences_updated_at"
  end

  create_table "property_occurrences", :force => true do |t|
    t.text    "number",                     :null => false
    t.integer "property_id", :default => 0, :null => false
  end

  add_index "property_occurrences", ["property_id"], :name => "fk_occurrence_property"

  create_table "unique_properties", :force => true do |t|
    t.integer  "number",                     :default => 0,  :null => false
    t.text     "statement",                                  :null => false
    t.string   "display",      :limit => 20, :default => "", :null => false
    t.string   "interest",     :limit => 20, :default => "", :null => false
    t.string   "truth",        :limit => 20, :default => "", :null => false
    t.string   "uniqueness",   :limit => 20, :default => "", :null => false
    t.string   "helper",       :limit => 50
    t.text     "proof_credit"
    t.text     "source"
    t.text     "comments"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

end
