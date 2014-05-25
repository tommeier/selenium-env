#require 'jasmine_selenium_runner'
#require 'jasmine_selenium_runner/configure_jasmine'
require_relative 'jasmine/runner'
require_relative 'jasmine/selenium_env_for_jasmine'


module SeleniumEnv::Framework::Jasmine

  def self.configure!
    STDOUT.puts 'SETTING UP JASMINE' * 50
    Jasmine.configure do |config|
      #runner_config = load_config
      #STDOUT.puts runner_config
      #config.ci_port = 5555 if runner_config['use_sauce'] #Sauce only proxies certain ports

      config.runner = lambda { |formatter, jasmine_server_url|
        ::SeleniumEnvForJasmine.new(formatter, jasmine_server_url).make_runner
      }
    end

    #framework.enable_after_suite_callback!

    # Set selenium env for jasmine as the runner
    # Set selenium env credentials

  end

  # def self.install_selenium_runner
  #    Jasmine.configure do |config|
  #      runner_config = load_config
  #      config.ci_port = 5555 if runner_config['use_sauce'] #Sauce only proxies certain ports

  #      config.runner = lambda { |formatter, jasmine_server_url|
  #        configuration_class = if runner_config['configuration_class']
  #                                const_get(runner_config['configuration_class'])
  #                              else
  #                                self
  #                              end
  #        configuration_class.new(formatter, jasmine_server_url, runner_config).make_runner
  #      }
  #    end
  #  end

  # def enable_after_suite_callback!
  #   ::Jasmine::Runners::Selenium.class_eval do
  #     attr_accessor :after_suite_callback

  #     def run_with_callbacks
  #       run_without_callbacks
  #     ensure
  #       if after_suite_callback && after_suite_callback.is_a?(Proc)
  #         after_suite_callback.call
  #       end
  #     end
  #     alias_method_chain :run, :callbacks
  #   end
  # end

  def install_custom_selenium_runner!


    # ::JasmineSeleniumRunner::ConfigureJasmine.class_eval do
    #   def local_webdriver
    #     STDOUT.puts "IN LOCAL WEBDRIVER" * 40
    #     Selenium::WebDriver.for(browser.to_sym, selenium_options)
    #   end

    #   def initialize_with_selenium_env(formatter, jasmine_server_url, runner_config)
    #     STDOUT.puts "INITIALIZE WITH SEL ENV"
    #     initialize_without_selenium_env(formatter, jasmine_server_url, runner_config)
    #     # Ignore yaml as we should be setting via env variables
    #     @runner_config = {}
    #     STDOUT.puts "END OF INITIALIZE WITH SEL ENV"
    #   end
    #   alias_method_chain :initialize, :selenium_env

    #     class << self
    #     def install_selenium_runner_with_selenium_env
    #       STDOUT.puts "IN HERE" * 200
    #       #_with_selenium_env

    #     end
    #     alias_method_chain :install_selenium_runner, :selenium_env
    #   #alias_method :install_selenium_runner_without_selenium_env, :install_selenium_runner
    #   #alias_method :install_selenium_runner, :install_selenium_runner_with_selenium_env
    #   end
  end
end
