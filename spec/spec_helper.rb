$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'bundler/setup'
require 'rspec'
require 'vcr'
require 'ruby-debug'
require 'gtfs'

require File.expand_path(File.dirname(__FILE__) + '/support/model_shared_examples')

RSpec.configure do |config|
  # Configure you some RSpec
end

VCR.config do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/fixtures/cassettes')
  c.stub_with :fakeweb
end
