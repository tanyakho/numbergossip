class InitialSchema < ActiveRecord::Migration
  def self.up
    create_table "properties", :force => true do |t|
      t.column "adjective", :string, :limit => 100, :default => "", :null => false
      t.column "alternate_adjective", :string, :limit => 100
      t.column "plural_noun", :string, :limit => 200, :default => "", :null => false
      t.column "definition", :text, :default => "", :null => false
      t.column "manual_coolness", :integer
      t.column "manual_knowledge_bound", :integer
    end

    create_table "property_occurrences", :force => true do |t|
      t.column "number", :text, :default => "", :null => false
      t.column "property_id", :integer, :default => 0, :null => false
    end

    add_index "property_occurrences", ["property_id"], :name => "fk_occurrence_property"

    create_table "unique_properties", :force => true do |t|
      t.column "number", :integer, :default => 0, :null => false
      t.column "statement", :text, :default => "", :null => false
      t.column "display", :string, :limit => 20, :default => "", :null => false
      t.column "interest", :string, :limit => 20, :default => "", :null => false
      t.column "truth", :string, :limit => 20, :default => "", :null => false
      t.column "uniqueness", :string, :limit => 20, :default => "", :null => false
      t.column "helper", :string, :limit => 50
      t.column "proof_credit", :text
      t.column "source", :text
      t.column "comments", :text
    end
  end

  def self.down
    drop_table :properties
    drop_table :property_occurrences
    drop_table :unique_properties
  end
end
