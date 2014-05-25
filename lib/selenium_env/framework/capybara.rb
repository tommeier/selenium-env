class SeleniumEnv::Framework::Capybara
  def self.configure!
    Capybara.register_driver :selenium_env do |app|
      Capybara::Selenium::Driver.new(
          app, SeleniumEnv.display.selenium_options
        ).tap do |driver|
        if SeleniumEnv.display.resizable
          driver.browser.manage.window.size = SeleniumEnv.display.device
        end
      end
    end
    Capybara.javascript_driver = :selenium_env
    Capybara.default_wait_time = 10
  end
end
