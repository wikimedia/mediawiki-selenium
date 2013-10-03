=begin
This file is subject to the license terms in the LICENSE file found in the
mediawiki-selenium top-level directory of and at
https://github.com/zeljkofilipin/mediawiki-selenium/blob/master/LICENSE. No part of
mediawiki-selenium, including this file, may be copied, modified, propagated, or
distributed except according to the terms contained in the LICENSE file.
Copyright 2013 by the Mediawiki developers. See the CREDITS file in the
mediawiki-selenium top-level directory and at
https://github.com/zeljkofilipin/mediawiki-selenium/blob/master//CREDITS.
=end

config = YAML.load_file('config/config.yml')

Before('@login') do
  puts "MEDIAWIKI_USER environment variable is not defined! Please export a value for that variable before proceeding." unless ENV['MEDIAWIKI_USER']
  puts "MEDIAWIKI_PASSWORD environment variable is not defined! Please export a value for that variable before proceeding." unless ENV['MEDIAWIKI_PASSWORD']
end

Before('@language') do |scenario|
  @language = true
  @scenario = scenario
end

Before do |scenario|
  @config = config
  @random_string = Random.new.rand.to_s
  unless @language # only UniversalLanguageSelector needs this
    @browser = browser(environment, test_name(scenario), 'default')
    $session_id = @browser.driver.instance_variable_get(:@bridge).session_id
  end
end

After do |scenario|
  if environment == :saucelabs
    sauce_api(%Q{{"passed": #{scenario.passed?}}})
    sauce_api(%Q{{"public": true}})
  end
  @browser.close unless ENV['KEEP_BROWSER_OPEN'] == 'true'
end

# only UniversalLanguageSelector needs this

Before('@uls-in-personal-only') do |scenario|
  if uls_position() != 'personal'
    scenario.skip_invoke!
  end
end

Before('@uls-in-sidebar-only') do |scenario|
  if uls_position() != 'interlanguage'
    scenario.skip_invoke!
  end
end

After('@reset-preferences-after') do |scenario|
  visit(ResetPreferencesPage)
  on(ResetPreferencesPage).submit_element.click
end
