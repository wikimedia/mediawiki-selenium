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

Before("@custom-browser") do |scenario|
  @scenario = scenario
end

Before("@login") do
  ENV["MEDIAWIKI_PASSWORD"] = ENV[ENV["MEDIAWIKI_PASSWORD_VARIABLE"]] if ENV["MEDIAWIKI_PASSWORD_VARIABLE"]
  puts "MEDIAWIKI_USER environment variable is not defined! Please export a value for that variable before proceeding." unless ENV["MEDIAWIKI_USER"]
  puts "MEDIAWIKI_PASSWORD environment variable is not defined! Please export a value for that variable before proceeding." unless ENV["MEDIAWIKI_PASSWORD"]
end

Before do |scenario|
  @random_string = Random.new.rand.to_s
  if ENV["REUSE_BROWSER"] == "true" and $browser # CirrusSearch and VisualEditor need this
    @browser = $browser
  elsif scenario.source_tag_names.include? "@custom-browser"
    # browser will be started in Cucumber step
  else
    @browser = browser(test_name(scenario))
    $browser = @browser # CirrusSearch and VisualEditor need this
    $session_id = @browser.driver.instance_variable_get(:@bridge).session_id
  end
end

After do |scenario|
  if @browser && scenario.failed? && (ENV["SCREENSHOT_FAILURES"] == "true")
    require "fileutils"
    screen_dir = ENV["SCREENSHOT_FAILURES_PATH"] || "screenshots"
    FileUtils.mkdir_p screen_dir
    name = test_name(scenario).gsub(/ /, '_')
    path = "#{screen_dir}/#{name}.png"
    @browser.screenshot.save path
    embed path, "image/png"
  end
  if environment == :saucelabs
    sauce_api(%Q{{"passed": #{scenario.passed?}}})
    sauce_api(%Q{{"public": true}})
    sauce_api(%Q{{"build": #{ENV["BUILD_NUMBER"]}}}) if ENV["BUILD_NUMBER"]
  end
  @browser.close unless ENV["KEEP_BROWSER_OPEN"] == "true" or ENV["REUSE_BROWSER"] == "true" # CirrusSearch and VisualEditor need this
end
