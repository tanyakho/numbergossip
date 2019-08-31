class AddOccurrenceTracking < ActiveRecord::Migration
  def self.up
    add_column :properties, :updated_at, :datetime
    add_column :properties, :occurrences_updated_at, :datetime
  end

  def self.down
    remove_column :properties, :updated_at
    remove_column :properties, :occurrences_updated_at
  end
end
