desc "Rebuild the full property database."
task :rebuild_database => [:rebuild_property_database, :rebuild_unique_database]

desc "Rebuild the normal property database."
task :rebuild_property_database => :environment do |t|
  Property.rebuild_database
end

desc "Rebuild the unique property database."
task :rebuild_unique_database => :environment do |t|
  UniqueProperty.parse_working_file
end
