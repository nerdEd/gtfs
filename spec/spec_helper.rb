require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler/setup'
require 'rspec'
require 'rspec/its'
require 'vcr'
require 'gtfs'

require File.expand_path(File.dirname(__FILE__) + '/support/model_shared_examples')

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should , :expect]
    expectations.on_potential_false_positives = :nothing
  end
end

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/fixtures/cassettes')
  c.hook_into :webmock
end
