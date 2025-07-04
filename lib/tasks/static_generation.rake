require_relative '../static_generator'

namespace :static do
  desc "Generate all static pages (1-9999 plus special pages)"
  task generate: :environment do
    # First compile assets
    puts "Compiling assets..."
    Rake::Task['assets:precompile'].invoke

    generator = StaticGenerator.new
    generator.generate_all
  end

  desc "Generate static pages for a specific range of numbers"
  task :generate_range, [:start_num, :end_num] => :environment do |t, args|
    start_num = args[:start_num]&.to_i || 1
    end_num = args[:end_num]&.to_i || 100

    puts "Generating pages from #{start_num} to #{end_num}"
    generator = StaticGenerator.new
    generator.generate_range(start_num, end_num)
  end

  desc "Generate only special pages (home, list, credits, etc.)"
  task generate_special: :environment do
    generator = StaticGenerator.new
    generator.generate_home_page
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

  desc "Compile and copy assets for static deployment"
  task compile_assets: :environment do
    puts "Compiling assets for static deployment..."

    # Precompile assets
    Rake::Task['assets:precompile'].invoke

    # Copy compiled assets to public directory
    if Dir.exist?('public/assets')
      puts "Assets already compiled and available in public/assets"
    else
      puts "Warning: No compiled assets found. Run 'rake assets:precompile' first."
    end

    # Copy individual asset files for legacy compatibility
    asset_files = {
      'app/assets/stylesheets/base.css.erb' => 'public/stylesheets/base.css',
      'app/assets/stylesheets/number_gossip.css' => 'public/stylesheets/number_gossip.css',
      'app/assets/javascripts/application.js' => 'public/javascripts/application.js',
      'app/assets/javascripts/prototype.js' => 'public/javascripts/prototype.js',
      'app/assets/javascripts/effects.js' => 'public/javascripts/effects.js'
    }

    asset_files.each do |source, dest|
      if File.exist?(source)
        FileUtils.mkdir_p(File.dirname(dest))
        if source.end_with?('.erb')
          # Process ERB file
          template = ERB.new(File.read(source))
          File.write(dest, template.result)
        else
          FileUtils.cp(source, dest)
        end
        puts "Copied #{source} to #{dest}"
      end
    end

    # Copy images
    if Dir.exist?('app/assets/images')
      FileUtils.mkdir_p('public/images')
      FileUtils.cp_r('app/assets/images/.', 'public/images/')
      puts "Copied images to public/images"
    end

    puts "Asset compilation complete!"
  end

  desc "Full static site generation (assets + pages)"
  task build: :environment do
    puts "Building complete static site..."

    Rake::Task['static:compile_assets'].invoke
    Rake::Task['static:generate'].invoke

    puts "Static site build complete!"
    puts "Your static site is ready in the public/ directory."
    puts "You can now deploy the contents of public/ to any web server."
  end
end
