# Simple client to configure for running tests over remote server
# For example: smoke tests with no local server running
class SeleniumEnv::RemoteClient::Remote < SeleniumEnv::RemoteClient::Base
  # Required: REMOTE_HOST
  def initialize(selenium_env)
    @selenium_env = selenium_env

    set_capybara_grid_options!
  end

  def set_capybara_grid_options!
    if @selenium_env.use_capybara?
      #Smoke tests
      Capybara.default_wait_time = 20

      Capybara.configure do |config|
        config.run_server = false
        config.app_host   = remote_host
      end
    end
  end

  def remote_host
    @remote_host ||= ENV['REMOTE_HOST']
  end

  def remote_address
    @remote_address ||= begin
      url = remote_host
      url =~ /\Ahttps?:\/\//i ? url : "http://#{url}"
    end
  end
end
