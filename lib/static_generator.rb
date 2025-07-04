require 'fileutils'
require 'stringio'
require 'concurrent'

class StaticGenerator
  attr_reader :output_dir, :app, :thread_pool_size

  def initialize(output_dir = 'public', thread_pool_size = 8)
    @output_dir = output_dir
    @app = Rails.application
    @thread_pool_size = thread_pool_size
  end

  def generate_all
    puts "Starting static generation..."
    start_time = Time.now

    # Ensure output directory exists
    FileUtils.mkdir_p(output_dir)

    # Generate home page
    generate_home_page

    # Generate number pages (1 through 9999)
    generate_number_pages

    # Generate special pages
    generate_special_pages

    end_time = Time.now
    duration = end_time - start_time
    puts "Static generation complete! Files saved to #{output_dir}/"
    puts "Total time: #{duration.round(2)} seconds"
    puts "Generated #{Dir.glob(File.join(output_dir, '*.html')).length} HTML files"
  end

  def generate_home_page
    puts "Generating home page..."

    html = get_page('/')
    save_page('index.html', html)
  end

  def generate_number_pages(start_num = 1, end_num = 9999)
    puts "Generating number pages (#{start_num} to #{end_num}) with #{thread_pool_size} threads..."

    # Create thread pool
    pool = Concurrent::FixedThreadPool.new(thread_pool_size)
    futures = []

    # Track progress with thread-safe counter
    completed = Concurrent::AtomicFixnum.new(0)
    total = end_num - start_num + 1

    # Submit all work to thread pool
    (start_num..end_num).each do |number|
      future = Concurrent::Future.execute(executor: pool) do
        begin
          html = get_page("/#{number}")
          save_page("#{number}.html", html)

          # Update progress
          current = completed.increment
          if current % 100 == 0 || current == total
            puts "  Generated #{current}/#{total} pages"
          end

        rescue => e
          puts "Error generating page for #{number}: #{e.message}"
        end
      end
      futures << future
    end

    # Wait for all to complete
    puts "Waiting for all pages to complete..."
    futures.each(&:wait)

    # Shutdown thread pool
    pool.shutdown
    pool.wait_for_termination

    puts "Number page generation complete!"
  end

  def generate_special_pages
    puts "Generating special pages..."

    special_pages = %w[list credits links contact editorial_policy status]

    special_pages.each do |page|
      puts "  Generating #{page}..."

      begin
        html = get_page("/#{page}")
        save_page("#{page}.html", html)

      rescue => e
        puts "Error generating #{page}: #{e.message}"
      end
    end
  end

  def generate_range(start_num, end_num)
    puts "Generating number pages from #{start_num} to #{end_num}..."
    generate_number_pages(start_num, end_num)
  end

  private

  def get_page(path)
    # Create a rack environment for the request
    env = {
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => path,
      'QUERY_STRING' => '',
      'SERVER_NAME' => 'localhost',
      'SERVER_PORT' => '80',
      'HTTP_HOST' => 'localhost',
      'rack.version' => [1, 3],
      'rack.url_scheme' => 'http',
      'rack.input' => StringIO.new,
      'rack.errors' => StringIO.new,
      'rack.multithread' => true,
      'rack.multiprocess' => false,
      'rack.run_once' => false
    }

    # Call the Rails application
    status, headers, body = app.call(env)

    # Check for errors
    if status >= 400
      raise "HTTP #{status} error for path #{path}"
    end

    # Handle different body types
    result = ""
    if body.respond_to?(:each)
      body.each { |chunk| result << chunk }
    else
      result = body.to_s
    end

    # Close the body if it responds to close (required by Rack spec)
    body.close if body.respond_to?(:close)

    result
  end

  def save_page(filename, html)
    file_path = File.join(output_dir, filename)

    # Ensure directory exists
    FileUtils.mkdir_p(File.dirname(file_path))

    File.write(file_path, html)
  end
end
