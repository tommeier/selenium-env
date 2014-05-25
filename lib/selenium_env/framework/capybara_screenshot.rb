# Setup capybara screenshot to use selenium env display
class SeleniumEnv::Framework::CapybaraScreenshot
  def self.configure!
    Capybara::Screenshot.register_driver(:selenium_env) do |driver, path|
      driver.save_screenshot(path)
    end
  end
end
