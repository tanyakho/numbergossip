require "rake/testtask.rb"

desc "Run the performance tests in test/performance."
Rake::TestTask.new("test_performance") { |t|
  t.libs << "test"
  t.pattern = 'test/performance/**/*_test.rb'
  t.verbose = true
}
task :test_performance => [ "db:test:clone_structure" ]

