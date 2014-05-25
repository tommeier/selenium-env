class SeleniumEnv::RemoteClient::BrowserStack < SeleniumEnv::RemoteClient::Base
  attr_reader :tunnel_pid

  def self.configure!(selenium_env)
    self.new(selenium_env)
  end

  def initialize(selenium_env)
    @selenium_env = selenium_env
  end

  def has_tunnel?
    true
  end

  # TODO: Auto download browserStackLocal if it doesn't exist
  #     : Config load of variables
  #     : Shared logging

  def start_tunnel!
    raise 'Error : Port must be set for BrowserStack to load tunnel correctly.' unless @selenium_env.port
    raise 'Error : REMOTE_ACCESS_KEY must be set for BrowserStack to load tunnel.' unless ENV['REMOTE_ACCESS_KEY']
    # Raise error if triggered without key env variables and port set
    # Get port set in here or on core?
    # 9sFqe1Hs8D3n7ehhSjh4 => accessKey

    @tunnel_pid = fork do
      cmd = "#{Rails.root.join('spec/support/BrowserStackLocal')} -onlyAutomate -v -force 9sFqe1Hs8D3n7ehhSjh4 localhost,#{@selenium_env.port},0"
      puts "Running: #{cmd}"
      exec cmd
    end
  end

  def close_tunnel!
    if @tunnel_pid
      STDOUT.puts "[browserstack] Terminating tunnel (#{@tunnel_pid})"
      Process.kill('TERM', @tunnel_pid) if process_exists?(@tunnel_pid)
    end
  end
end
