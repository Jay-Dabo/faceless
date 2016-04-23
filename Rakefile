require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/faceless/test_*.rb"
end

desc "Run tests"
task :default => :test