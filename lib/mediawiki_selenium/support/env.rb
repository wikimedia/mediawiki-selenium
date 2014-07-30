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

require "mediawiki_selenium/support/modules/api_helper"

World(PageObject::PageFactory)
World(MediawikiSelenium::ApiHelper)

def browser(test_name, configuration = nil)
  if environment == :saucelabs
    sauce_browser(test_name, configuration)
  else
    local_browser(configuration)
  end
end
def browser_name
  if ENV["BROWSER"]
    ENV["BROWSER"].to_sym
  else
    :firefox
  end
end
def environment
  if ENV["SAUCE_ONDEMAND_USERNAME"] and ENV["SAUCE_ONDEMAND_ACCESS_KEY"] and ENV["BROWSER"] != "phantomjs" and ENV["HEADLESS"] != "true"
    :saucelabs
  else
    :local
  end
end
def local_browser(configuration)
  if ENV["BROWSER_TIMEOUT"] && browser_name == :firefox
    timeout = ENV["BROWSER_TIMEOUT"].to_i

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = timeout

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["dom.max_script_run_time"] = timeout
    profile["dom.max_chrome_script_run_time"] = timeout
    browser = Watir::Browser.new browser_name, :http_client => client, :profile => profile
  elsif configuration && configuration[:language] && browser_name == :firefox
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["intl.accept_languages"] = configuration[:language]
    browser = Watir::Browser.new browser_name, profile: profile
  elsif configuration && configuration[:language] && browser_name == :chrome
    prefs = {intl: {accept_languages: configuration[:language]}}
    browser = Watir::Browser.new browser_name, prefs: prefs
  elsif configuration && configuration[:language] && browser_name == :phantomjs
    capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs
    capabilities["phantomjs.page.customHeaders.Accept-Language"] = configuration[:language]
    browser = Watir::Browser.new browser_name, desired_capabilities: capabilities
  elsif configuration && configuration[:user_agent] && browser_name == :firefox
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["general.useragent.override"] = configuration[:user_agent]
    browser = Watir::Browser.new browser_name, profile: profile
  else
    browser = Watir::Browser.new browser_name
  end

  browser.window.resize_to 1280, 1024
  set_cookie(browser)
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
def sauce_browser(test_name, configuration)
  abort "Environment variables BROWSER, PLATFORM and VERSION have to be set" if (ENV["BROWSER"] == nil) or (ENV["PLATFORM"] == nil) or (ENV["VERSION"] == nil)

  client = Selenium::WebDriver::Remote::Http::Default.new

  if ENV["BROWSER_TIMEOUT"] && ENV["BROWSER"] == "firefox"
    timeout = ENV["BROWSER_TIMEOUT"].to_i
    client.timeout = timeout

    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["dom.max_script_run_time"] = timeout
    profile["dom.max_chrome_script_run_time"] = timeout
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
  elsif configuration && configuration[:language] && ENV["BROWSER"] == "firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["intl.accept_languages"] = configuration[:language]
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
  elsif configuration && configuration[:language] && ENV["BROWSER"] == "chrome"
    profile = Selenium::WebDriver::Chrome::Profile.new
    profile["intl.accept_languages"] = configuration[:language]
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chrome.profile" => profile.as_json["zip"])
  elsif configuration && configuration[:user_agent] && ENV["BROWSER"] == "firefox"
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["general.useragent.override"] = configuration[:user_agent]
    caps = Selenium::WebDriver::Remote::Capabilities.firefox(:firefox_profile => profile)
  else
    caps = Selenium::WebDriver::Remote::Capabilities.send(ENV["BROWSER"])
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
def set_cookie(browser)
  # implement this method in env.rb of the repository where it is needed
end
def test_name(scenario)
  if scenario.respond_to? :feature
    "#{scenario.feature.title}: #{scenario.title}"
  elsif scenario.respond_to? :scenario_outline
    "#{scenario.scenario_outline.feature.title}: #{scenario.scenario_outline.title}: #{scenario.name}"
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
