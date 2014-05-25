require 'rails/railtie'
require 'jasmine'
STDOUT.puts "IN selenium_env/railtie " * 20
module SeleniumEnv
  class Railtie < Rails::Railtie
    rake_tasks do
      STDOUT.puts "LOADING RAILTIE" * 500
      load 'selenium_env/tasks/jasmine.rake'
    end
  end
end

