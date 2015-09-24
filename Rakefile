require 'rubygems'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = './spec/**/*_spec.rb'
end

task :console do
  require 'pry'
  require 'gtfs'
  ARGV.clear
  Pry.start
end

task :default => [:spec]
