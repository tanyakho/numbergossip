original_directory = "../public_html/Numbers"
desc "Compare copied definitions against originals, if possible"
task :diff_definitions do
  sh "diff -ub #{original_directory}/numbers.html db/properties/definitions.txt"
end

desc "Compare copied unique property definitions against originals, if possible"
task :diff_unique_source do
  sh "diff -ub #{original_directory}/Unique/uniqueWorking.txt db/properties/uniqueWorking.txt"
end

file "db/properties/unique_generated.txt" => [ :environment, "db/properties/uniqueWorking.txt" ] do |t|
  if File.exist? t.name
    rm t.name
  end
  UniqueProperty.parse_working_file
  File.open(t.name, "w") do |f|
    UniqueProperty.find_all.select { |u| u.display? }.map { |u| u.number }.sort.uniq.each do |num|
      f.puts "#{num}|||#{UniqueProperty.properties_of(num).map { |u| u.statement }.join("; ")}."
    end
  end
end

task :diff_unique_generated => "db/properties/unique_generated.txt" do
  sh "diff -b -U 0 #{original_directory}/Unique/unique.txt db/properties/unique_generated.txt"
end

task :diff_unique => [ :diff_unique_source, :diff_unique_generated ]

task :diff => [ :diff_unique, :diff_definitions ]
