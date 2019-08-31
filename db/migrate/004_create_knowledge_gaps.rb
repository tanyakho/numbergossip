class CreateKnowledgeGaps < ActiveRecord::Migration
  def self.up
    create_table :knowledge_gaps do |t|
      t.column :property_id, :integer
      t.column :number, :text
    end
  end

  def self.down
    drop_table :knowledge_gaps
  end
end
