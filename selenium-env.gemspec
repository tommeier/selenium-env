# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "selenium_env/version"

Gem::Specification.new do |spec|
  spec.name          = "selenium-env"
  spec.version       = SeleniumEnv::VERSION
  spec.authors       = ["Tom Meier"]
  spec.email         = ["tom@venombytes.com"]
  spec.summary       = %q{Generic ENV interface for selenium based tests}
  spec.description   = %q{
  Generic environment variable interface for multiple test clients (RSpec, Capybara, Jasmine)
  to run locally or remotely (Sauce, Selenium Grid, BrowserStack).
  }
  spec.homepage      = "https://github.com/tommeier/selenium-env"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionpack"
  spec.add_dependency "railties"
  spec.add_dependency 'jasmine', '~> 2.0.0.alpha'

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "cane"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sauce", "~> 3.1.1"
  spec.add_development_dependency "sauce-connect"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "sprockets-rails"
end
