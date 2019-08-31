class UniqueCreationTracking < ActiveRecord::Migration
  def self.up
    add_column :unique_properties, :updated_at, :datetime
    add_column :unique_properties, :created_at, :datetime
  end

  def self.down
    remove_column :unique_properties, :updated_at
    remove_column :unique_properties, :created_at
  end
end
