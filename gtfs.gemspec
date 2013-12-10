# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require './lib/gtfs/version'

Gem::Specification.new do |gem|
  gem.name    = 'gtfs'
  gem.version = GTFS::VERSION
  gem.date    = Date.today.to_s
 
  gem.summary = 'Load and read GTFS data from zip bundles'
  gem.description = 'gtfs reads GTFS data from a google-compliant Zip bundle 
                     and returns an object representing the CSV data inside'

  gem.authors     = ['nerdEd']
  gem.email       = ['ed@nerded.net']
  gem.homepage    = 'https://github.com/nerdEd/gtfs'

  gem.add_dependency 'rake'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'rubyzip', '< 1.0.0'

  gem.add_development_dependency 'rspec', ['>= 2.0.0']
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'ruby-debug19'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'fakeweb'

  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_paths = ['lib']
end
