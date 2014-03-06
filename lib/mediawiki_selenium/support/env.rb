=begin
This file is subject to the license terms in the LICENSE file found in the
mediawiki_selenium top-level directory and at
https://git.wikimedia.org/blob/mediawiki%2Fselenium/HEAD/LICENSE. No part of
mediawiki_selenium, including this file, may be copied, modified, propagated, or
distributed except according to the terms contained in the LICENSE file.
Copyright 2013 by the Mediawiki developers. See the CREDITS file in the
mediawiki_selenium top-level directory and at
https://git.wikimedia.org/blob/mediawiki%2Fselenium/HEAD/CREDITS.
=end

# before all
require "bundler/setup"
require "page-object"
require "page-object/page_factory"
require "rest_client"
require "watir-webdriver"
require "yaml"

World(PageObject::PageFactory)

def browser(environment, test_name, language)
  if environment == :saucelabs
    sauce_browser(test_name, language)
  else
    local_browser(language)
  end
end
def environment
  if ENV["SAUCE_ONDEMAND_USERNAME"] and ENV["SAUCE_ONDEMAND_ACCESS_KEY"] and ENV["BROWSER"] != "phantomjs"
    :saucelabs
  else
    :local
  end
end
def local_browser(language)
  if ENV["BROWSER"]
    browser_name = ENV["BROWSER"].to_sym
  else
    browser_name = :firefox
  end

  if language == "default" && ENV["BROWSER_TIMEOUT"] && browser_name == :firefox
    timeout = ENV["BROWSER_TIMEOUT"].to_i

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = timeout

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["dom.max_script_run_time"] = timeout
    profile["dom.max_chrome_script_run_time"] = timeout
    browser = Watir::Browser.new browser_name, :http_client => client, :profile => profile
  elsif language == "default"
    browser = Watir::Browser.new browser_name
  else
    if browser_name == :firefox
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile["intl.accept_languages"] = language
      browser = Watir::Browser.new browser_name, profile: profile
    elsif browser_name == :chrome
      profile = Selenium::WebDriver::Chrome::Profile.new
      profile["intl.accept_languages"] = language
      browser = Watir::Browser.new browser_name, profile: profile
    elsif browser_name == :phantomjs
      capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs
      capabilities["phantomjs.page.customHeaders.Accept-Language"] = language
      browser = Watir::Browser.new browser_name, desired_capabilities: capabilities
    else
      raise "Changing default language is currently supported only for Chrome, Firefox and PhantomJS!"
    end
  end

  browser.window.resize_to 1280, 1024
  browser
end
def sauce_api(json)
RestClient::Request.execute(
  :method => :put,
  :url => "https://saucelabs.com/rest/v1/#{ENV['SAUCE_ONDEMAND_USERNAME']}/jobs/#{$session_id}",
  :user => ENV["SAUCE_ONDEMAND_USERNAME"],
  :password => ENV["SAUCE_ONDEMAND_ACCESS_KEY"],
  :headers => {:content_type => "application/json"},
  :payload => json
)
end
def sauce_browser(test_name, language)
  abort "Environment variables BROWSER, PLATFORM and VERSION have to be set" if (ENV["BROWSER"] == nil) or (ENV["PLATFORM"] == nil) or (ENV["VERSION"] == nil)

  require "selenium/webdriver/remote/http/persistent" # http_client
  client = Selenium::WebDriver::Remote::Http::Persistent.new

  if language == "default" && ENV["BROWSER_TIMEOUT"] && ENV["BROWSER"] == "firefox"
    timeout = ENV["BROWSER_TIMEOUT"].to_i
    client.timeout = timeout

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["dom.max_script_run_time"] = timeout
    profile["dom.max_chrome_script_run_time"] = timeout
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
  elsif language == "default"
    caps = Selenium::WebDriver::Remote::Capabilities.send(ENV["BROWSER"])
  elsif ENV["BROWSER"] == "firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["intl.accept_languages"] = language
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
  elsif ENV["BROWSER"] == "chrome"
    profile = Selenium::WebDriver::Chrome::Profile.new
    profile["intl.accept_languages"] = language
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chrome.profile" => profile.as_json["zip"])
  end

  caps.platform = ENV["PLATFORM"]
  caps.version = ENV["VERSION"]
  caps[:name] = "#{test_name} #{ENV['JOB_NAME']}##{ENV['BUILD_NUMBER']}"

  browser = Watir::Browser.new(
    :remote,
    http_client: client,
    url: "http://#{ENV['SAUCE_ONDEMAND_USERNAME']}:#{ENV['SAUCE_ONDEMAND_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub",
    desired_capabilities: caps)
  browser.wd.file_detector = lambda do |args|
    # args => ["/path/to/file"]
    str = args.first.to_s
    str if File.exist?(str)
  end

  browser
end
def test_name(scenario)
  if scenario.respond_to? :feature
    "#{scenario.feature.name}: #{scenario.name}"
  elsif scenario.respond_to? :scenario_outline
    "#{scenario.scenario_outline.feature.name}: #{scenario.scenario_outline.name}: #{scenario.name}"
  end
end

if ENV["HEADLESS"] == "true"
  require "headless"
  headless = Headless.new
  headless.start
end

at_exit do
  headless.destroy if headless
end
