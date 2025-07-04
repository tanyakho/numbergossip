require_relative '../static_generator'

namespace :static do
  desc "Generate all static pages (1-9999 plus special pages)"
  task generate: :environment do
    # First compile assets
    puts "Compiling assets..."
    Rake::Task['assets:precompile'].invoke

    generator = StaticGenerator.new('public', 8)
    generator.generate_all
    puts "Static site build complete!"
    puts "Your static site is ready in the public/ directory."
    puts "You can now deploy the contents of public/ to any web server."
  end

  desc "Generate static pages for a specific range of numbers"
  task :generate_range, [:start_num, :end_num] => :environment do |t, args|
    start_num = args[:start_num]&.to_i || 1
    end_num = args[:end_num]&.to_i || 100

    puts "Generating pages from #{start_num} to #{end_num}"
    generator = StaticGenerator.new('public', 8)
    generator.generate_home_page
    generator.generate_range(start_num, end_num)
    generator.generate_special_pages
  end

  desc "Generate a test batch of pages (first 10 numbers)"
  task generate_test: :environment do
    generator = StaticGenerator.new('public', 8)
    generator.generate_home_page
    generator.generate_number_pages(1, 10)
    generator.generate_special_pages
    puts "Test generation complete! Check the public/ directory."
  end

  desc "Clean up generated static files"
  task clean: :environment do
    puts "Cleaning up static files..."

    # Remove generated pages
    Dir.glob('public/**/index.html').each do |file|
      File.delete(file)
      puts "Deleted #{file}"
    end

    puts "Cleanup complete!"
  end

end
