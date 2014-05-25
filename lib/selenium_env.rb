require "selenium_env/version"
require "selenium-webdriver"
Device = Struct.new(:width, :height)

module SeleniumEnv

  class << self
    attr_accessor :remote_client
    attr_accessor :browser, :device, :device_name,
      :resizable, :browser_capability,
      :port, :selenium_options

    def self.display
      @display ||= self.new
    end

    def self.configure!
      self.display
    end

    def initialize(overrides = {})
      STDOUT.puts "INITINIALISING SELENIUM ENV"
      # Browser options
      self.browser      = (ENV['BROWSER']  || 'firefox').strip.downcase
      self.resizable    = true # Default

      # TODO: Can I burn this?
      self.port         = overrides[:port] || (8765 + (ENV['EXECUTOR_NUMBER'] || '0').to_i)

      self.selenium_options = { browser: self.browser.to_sym }

      define_browser_capability

      self.device_name    = ENV['DEVICE'] || 'desktop'
      self.device         = define_device(device_name)
      self.remote_client  = setup_remote_client!(ENV['REMOTE_CLIENT'].to_s.to_sym)

      setup_frameworks!

      print_debug_info if ENV['SELENIUM_DEBUG']
    end

    [:remote, :grid, :browser_stack].each do |remote_client_name|
      define_method("#{remote_client_name}?") do
        ENV['REMOTE_CLIENT'].to_sym == remote_client_name
      end
    end

    def use_capybara?
      @use_capybara ||= defined?(Capybara)
    end

    def use_capybara_screenshot?
      @use_capybara_screenshot ||= defined?(Capybara::Screenshot)
    end

    def use_jasmine?
      STDOUT.puts "IN HERE" * 500
      @use_jasmine ||= defined?(Jasmine)
    end

    def method_missing(method_name, *args, &block)
      client_method_white_list = [:has_tunnel?, :close_tunnel!, :start_tunnel!]
      if client_method_white_list.include?(method_name.to_sym)
        if remote_client && remote_client.responds_to?(method_name)
          remote_client.public_send(method_name, *args, &block)
        else
          nil
        end
      else
        super
      end
    end

    private

    def define_device(device_type)
      case device_type.strip.downcase
      when 'phone'
        Device.new(320, 480) #IPhone dimensions
      when 'tablet'
        Device.new(1024, 768)
      when 'desktop'
        Device.new(1400, 900)
      when 'cinema-desktop'
        Device.new(2560, 1440)
      else
        raise "Error - Unsupported device type '#{device_type}'"
      end
    end

    def define_browser_capability
      case browser
      when /ie\d+/
        self.browser_capability = Selenium::WebDriver::Remote::Capabilities.ie
        self.browser_capability.version = browser.match(/ie(?<version>\d+)/)[:version]
        self.browser_capability.platform = 'windows'
        self.browser = 'ie'
      when 'chrome'
        self.browser_capability = Selenium::WebDriver::Remote::Capabilities.chrome
      when 'ipad'
        self.browser_capability = Selenium::WebDriver::Remote::Capabilities.ipad
        self.resizable = false
      when 'iphone'
        self.browser_capability = Selenium::WebDriver::Remote::Capabilities.iphone
        self.resizable = false
      when 'firefox'
        self.browser_capability = Selenium::WebDriver::Remote::Capabilities.firefox
        profile = Selenium::WebDriver::Firefox::Profile.new
        # disable autoupdate on load of firefox
        profile['extensions.update.enabled'] = false
        profile['app.update.auto'] = false
        profile['app.update.enabled'] = false
        self.selenium_options.merge!({ :profile => profile })
      else
        raise "Error - Unsupported browser format '#{browser}'"
      end
    end

    def setup_frameworks!
      SeleniumEnv::Framework::Capybara.configure!           if use_capybara?
      SeleniumEnv::Framework::CapybaraScreenshot.configure! if use_capybara_screenshot?
      SeleniumEnv::Framework::Jasmine.configure!            if use_jasmine?
    end

    def setup_remote_client!(client_name)
      client =  case client_name
      when :grid
        SeleniumEnv::RemoteClient::Grid
      when :remote
        SeleniumEnv::RemoteClient::Remote
      when :browser_stack
        SeleniumEnv::RemoteClient::BrowserStack
      end

      client.configure!(self) if client
    end

    # # Remote client helpers
    # def has_tunnel?
    #   remote_client && remote_client.has_tunnel?
    # end

    # # Close any tunnel if remote client loaded and using tunnel
    # def close_tunnel!
    #   if has_tunnel?
    #     remote_client.close_tunnel!
    #   end
    # end



    # TODO : pass this through via method missing, and check if remote_client && remote_client responds to method

    # TODO : start tunnel (block to wrap tunnel command?)

    # TODO : Include debug content from remote clients or frameworks

    def print_debug_info
      STDERR.puts ' >> Loading Selenium env'
      STDERR.puts "   ->> port        : #{port}"
      STDERR.puts "   ->> browser     : #{browser}"
      STDERR.puts "   ->> device type : #{device_name}"
      STDERR.puts "   ->> device      : #{device}"
      STDERR.puts "   ->> options     : #{selenium_options}"
    end
  end

  require 'selenium_env/framework'
  require 'selenium_env/framework/jasmine'
  require 'selenium_env/framework/capybara'
  require 'selenium_env/framework/capybara_screenshot'

  require 'selenium_env/remote_client'
  require 'selenium_env/remote_client/base'
  require 'selenium_env/remote_client/grid'
  require 'selenium_env/remote_client/remote'
end

require 'selenium_env/railtie'

SeleniumEnv.configure!
