# SeleniumEnv

[![Build Status](https://travis-ci.org/tommeier/selenium-env.png)](https://travis-ci.org/tommeier/selenium-env
[![Selenium Test Status](https://saucelabs.com/buildstatus/selenium-env)](https://saucelabs.com/u/selenium-env)
[![Selenium Test Status](https://saucelabs.com/browser-matrix/selenium-env.svg)](https://saucelabs.com/u/selenium-env)

Using Selenium can get very complicated, very fast, especially with multiple libraries each bringing their own connectors and interface. This project seeks to go back to basics, a single, environment variable based interface to apply custom selenium settings across multiple testing libraries and remote test clients (ie: SauceLabs or BrowserStack).


## Installation

Add this gem to your application's Gemfile `test` group:

  ```
group :test do
  gem 'selenium-env'
end
  ```

And then execute:

    `$ bundle`

Or install it yourself as:

    `$ gem install selenium-env`

## Usage

TODO

## Contributing

1. Fork it ( http://github.com/tommeier/selenium-env/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add specs and ensure all tests pass (in multiple configurations)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Running tests

To display in Chrome browsers locally, ensure you have the latest `chromedriver` installed:

`brew install chromedriver`

### Running all tests, with setup:

`script/spec`

### Running features only in Chrome

`BROWSER=chrome rspec spec/features`

### Running features only in Firefox (default)

`BROWSER=firefox rspec spec/features`

## Appendix

### How to to generate dummy rails app for test structure (use when updating rails major versions)

  * Command for dummy rails app
  * Scaffolding request objects:
    * `rm -rf spec/dummy && mkdir spec/dummy`
    * `rails generate scaffold TestApp subject:text:uniq body:text published:boolean`
