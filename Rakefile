require 'rubygems'
require 'rspec/core/rake_task'
require 'net/http'
require 'uri'

require './lib/gtfs/version'

RSpec::Core::RakeTask.new do |t|
  t.pattern = './spec/**/*_spec.rb'
end

task :default => [:spec]

# Task to check if versin exists on rubygems
task :check_version do
  version = GTFS::VERSION
  # query api
  url = "https://rubygems.org/api/v2/rubygems/gtfs/versions/#{version}"

  response = Net::HTTP.get_response(URI.parse(url))

  if response.code == '200'
    puts "Version #{version} exists on rubygems"
    exit 1
  end

  puts "Version #{version} does not exist on rubygems"
  exit 0
end
