class SeleniumEnv::RemoteClient::Base
  attr_accessor :selenium_env

  def self.configure!(selenium_env)
    self.new(selenium_env)
  end

  def has_tunnel?
    false
  end

  def close_tunnel!
    true
  end

  def process_exists?(pid)
    Process.getpgid(pid)
    true
  rescue Errno::ESRCH
    false
  end
end
