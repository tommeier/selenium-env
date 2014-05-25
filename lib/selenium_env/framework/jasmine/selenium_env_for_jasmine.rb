# require 'jasmine_selenium_runner'
# require 'jasmine_selenium_runner/configure_jasmine'
# require 'open-uri'

# require 'jasmine'
# require 'jasmine/runners/selenium'
require 'selenium-webdriver'

# module JasmineSeleniumRunner
#   class ConfigureJasmine
#     # def self.install_selenium_runner
#     #   Jasmine.configure do |config|
#     #     runner_config = load_config
#     #     config.ci_port = 5555 if runner_config['use_sauce'] #Sauce only proxies certain ports

    #     config.runner = lambda { |formatter, jasmine_server_url|
    #       configuration_class = if runner_config['configuration_class']
    #                               const_get(runner_config['configuration_class'])
    #                             else
    #                               self
    #                             end
    #       configuration_class.new(formatter, jasmine_server_url, runner_config).make_runner
    #     }
    #   end
    # end

    # def self.load_config
    #   filepath = File.join(Dir.pwd, 'spec', 'javascripts', 'support', 'jasmine_selenium_runner.yml')
    #   if File.exist?(filepath)
    #     YAML::load(ERB.new(File.read(filepath)).result(binding))
    #   else
    #     {}
    #   end
    # end

    # def initialize(formatter, jasmine_server_url, runner_config)
    #   @formatter = formatter
    #   @jasmine_server_url = jasmine_server_url
    #   @runner_config = runner_config
    #   @browser = runner_config['browser'] || 'firefox'
    # end

    # def make_runner
    #   webdriver = nil
    #   if runner_config['use_sauce']
    #     webdriver = sauce_webdriver(runner_config['sauce'])
    #   elsif runner_config['selenium_server']
    #     webdriver = remote_webdriver(runner_config['selenium_server'])
    #   else
    #     webdriver = local_webdriver
    #   end

    #   Jasmine::Runners::Selenium.new(formatter, jasmine_server_url, webdriver, batch_size)
    # end

    # def batch_size
    #   runner_config['batch_config_size'] || 50
    # end

#     def sauce_webdriver(sauce_config)
#       unless sauce_config['tunnel_identifier']
#         require 'sauce/connect'
#         Sauce::Connect.connect!
#       end

#       username = sauce_config.fetch('username')
#       key = sauce_config.fetch('access_key')
#       driver_url = "http://#{username}:#{key}@localhost:4445/wd/hub"

#       capabilities = {
#         :name => sauce_config['name'],
#         :platform => sauce_config['os'],
#         :version => sauce_config['browser_version'],
#         :build => sauce_config['build'],
#         :tags => sauce_config['tags'],
#         :browserName => browser,
#         'tunnel-identifier' => sauce_config['tunnel_identifier']
#       }

#       Selenium::WebDriver.for :remote, :url => driver_url, :desired_capabilities => capabilities
#     end

#     def remote_webdriver(server_url)
#       Selenium::WebDriver.for :remote, :url => server_url, :desired_capabilities => browser.to_sym
#     end

#     def local_webdriver
#       Selenium::WebDriver.for(browser.to_sym, selenium_options)
#     end

#     def selenium_options
#       if browser == 'firefox-firebug'
#         require File.join(File.dirname(__FILE__), 'firebug/firebug')
#         profile = Selenium::WebDriver::Firefox::Profile.new
#         profile.enable_firebug
#         { :profile => profile }
#       else
#         {}
#       end
#     end

#     protected
#     attr_reader :formatter, :jasmine_server_url, :runner_config, :browser
#   end
# end



class SeleniumEnvForJasmine

  def initialize(formatter, jasmine_server_url)
    @formatter = formatter
    @jasmine_server_url = jasmine_server_url
    @browser = SeleniumEnv.display.browser
  end

  def make_runner
    # webdriver = nil
    # if runner_config['use_sauce']
    #   webdriver = sauce_webdriver(runner_config['sauce'])
    # elsif runner_config['selenium_server']
    #   webdriver = remote_webdriver(runner_config['selenium_server'])
    # else
    #   webdriver = local_webdriver
    # end

    runner = SeleniumEnv::Framework::Jasmine::Runner.new(
              formatter,
              jasmine_server_url,
              local_webdriver,
              test_batch_size
             )
    runner.before_suite_callback = Proc.new {
      SeleniumEnv.display.start_tunnel!
    }

    runner.after_suite_callback = Proc.new {
      SeleniumEnv.display.close_tunnel!
    }
    runner
  end

  def local_webdriver
    Selenium::WebDriver.for(SeleniumEnv.display.browser.to_sym, SeleniumEnv.display.selenium_options.except(:browser))
  end

  # TODO: make this env settable
  def test_batch_size
    50
  end

  # def make_runner
  #   driver = super
  #    driver.after_suite_callback = Proc.new {
  #      SeleniumEnv.current_display.close_tunnel!
  #    }
  #   driver
  # end

  # def remote_webdriver(server_url)
  #   #if SeleniumEnv.current_display.has_tunnel?
  #     remote_webdriver_with_tunnel(server_url)
  #   #else
  #   #  super(server_url)
  #   #end
  # end

  # def remote_webdriver_with_tunnel(server_url)
  #   puts "Remote server url: #{server_url}"
  #   puts "Jasmine server_url : #{@jasmine_server_url}"

  #   if SeleniumEnv.current_display.has_tunnel?
  #     uri = URI.parse(@jasmine_server_url)
  #     SeleniumEnv.current_display.port = uri.port #Force to jasmine server port
  #     SeleniumEnv.current_display.remote_client.start_tunnel!
  #   end

  #   puts "Loading for test"
  #   caps = Selenium::WebDriver::Remote::Capabilities.firefox
  #   #Selenium::WebDriver::Remote::Capabilities.new
  #   #caps["browser"] = ENV['BROWSER'] || "firefox"
  #   # caps["browser_version"] = "7.0"
  #   # caps["os"] = "Windows"
  #   # caps["os_version"] = "XP"
  #   #caps["browserstack.debug"] = "true"
  #   caps["browserstack.local"] = "true"
  #   caps[:name] = "Jasmine"

  #   # TODO make this an optional block with_tunnel (if required)
  #   retry_attempt = 0
  #   begin
  #     Selenium::WebDriver.for(:remote,
  #         :url => server_url,
  #         :desired_capabilities => caps)
  #   rescue Selenium::WebDriver::Error::UnknownError => e
  #     #[browserstack.local] is set to true but local testing through BrowserStack is not connected.
  #     if retry_attempt < 10 && e.message =~ /BrowserStack is not connected/
  #       retry_attempt += 1
  #       STDOUT.puts "[browserstack] Tunnel not connected. Retrying... (attempt: #{retry_attempt})"
  #       sleep 0.1
  #       retry
  #     else
  #       raise e
  #     end
  #   end
  # end

  protected

  attr_reader :formatter, :jasmine_server_url, :browser
end
