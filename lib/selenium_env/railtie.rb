require 'rails/railtie'
#require 'jasmine'
STDOUT.puts "IN selenium_env/railtie " * 20
module
  class Railtie < Rails::Railtie
    initializer "jasmine.initializer", :after => :load_environment_hook do
      STDOUT.puts "IN JASMINE INITIALISER VIA SEL-ENV" * 200
    end

    rake_tasks do
      require 'selenium_env/tasks/jasmine.rake'
      STDOUT.puts "LOADING RAILTIE" * 500
      load 'selenium_env/tasks/jasmine.rake'
    end
  end
end

