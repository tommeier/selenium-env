namespace :jasmine_selenium_env do
  desc "Ensure selenium-env is loaded and configured with jasmine"
  task :setup => :environment do
    STDOUT.puts "IN HERE"
    require 'selenium-env'
  end
end

task 'jasmine:require' => ['jasmine_selenium_env:setup']
