require_relative '../static_generator'

namespace :static do
  desc "Generate all static pages (1-9999 plus special pages)"
  task generate: :environment do
    # First compile assets
    puts "Compiling assets..."
    Rake::Task['assets:precompile'].invoke

    # Configure assets for static generation
    original_debug = Rails.application.config.assets.debug
    Rails.application.config.assets.debug = false

    begin
      generator = StaticGenerator.new('public', 8)
      generator.generate_all
    ensure
      Rails.application.config.assets.debug = original_debug
    end

    puts "Static site build complete!"
    puts "Your static site is ready in the public/ directory."
    puts "You can now deploy the contents of public/ to any web server."
  end

  desc "Generate static pages for a specific range of numbers"
  task :generate_range, [:start_num, :end_num] => :environment do |t, args|
    generate_in_range(args[:start_num]&.to_i || 1, args[:end_num]&.to_i || 10)
  end

  def generate_in_range(start_num, end_num)
    # Configure assets for static generation
    original_debug = Rails.application.config.assets.debug
    Rails.application.config.assets.debug = false

    begin
      puts "Generating pages from #{start_num} to #{end_num}"
      generator = StaticGenerator.new('public', 8)
      generator.generate_home_page
      generator.generate_range(start_num, end_num)
      generator.generate_special_pages
    ensure
      Rails.application.config.assets.debug = original_debug
    end
  end

  desc "Generate a test batch of pages (first 10 numbers)"
  task generate_test: :environment do
    generate_in_range(1, 10)
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
