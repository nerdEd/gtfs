require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler/setup'
require 'rspec'
require 'vcr'
require 'gtfs'

require File.expand_path(File.dirname(__FILE__) + '/support/model_shared_examples')

VCR.configure do |config|
  config.cassette_library_dir = File.join(File.dirname(__FILE__), '/fixtures/cassettes')
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
