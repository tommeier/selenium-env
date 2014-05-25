class SeleniumEnv::RemoteClient::Grid < SeleniumEnv::RemoteClient::Base
  # OPTIONAL: GRID_HOST
  def initialize(selenium_env)
    @selenium_env = selenium_env

    grid_server = if ENV['GRID_HOST']
      ENV['GRID_HOST']
    else
      'localhost' #grid.local
    end

    grid_client = Selenium::WebDriver::Remote::Http::Default.new
    grid_client.timeout = 240

    #Additional criteria required when running a grid based selenium display
    @selenium_env.browser = :remote
    @selenium_env.selenium_options.merge!({
      :browser              => @selenium_env.browser,
      :url                  => "http://#{grid_server}:4444/wd/hub",
      :desired_capabilities => @browser_capability,
      :http_client          => grid_client
    })

    set_capybara_grid_options!
  end

  def set_capybara_grid_options!
    if @selenium_env.use_capybara?
      Capybara.server_port        = @selenium_env.port
      Capybara.app_host           = local_address
      Capybara.default_wait_time  = 30
    end
  end

  def local_address
    @local_address ||= "http://#{local_ip}:#{port}"
  end

  def local_ip
    require 'socket' #to work out ipaddress to tell grid clients
    server_dns = ENV['SERVER_DNS'] || 'dns.ferocia.com.au'

    @local_ip ||= UDPSocket.open do |s|
      s.connect server_dns, 1
      s.addr.last
    end
  rescue SocketError
    # Not connected to a network, use local ip
    STDOUT.puts '[selenium-display] Cannot connect to network defaulting ip to 0.0.0.0.'
    '0.0.0.0'
  end
end
