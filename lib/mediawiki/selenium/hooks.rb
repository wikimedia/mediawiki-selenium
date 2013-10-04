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

Before do |scenario|
  @config = config
  @random_string = Random.new.rand.to_s
  if ENV['REUSE_BROWSER'] == 'true' and $browser # only CirrusSearch needs this
    @browser = $browser
  else
    unless @language # only UniversalLanguageSelector needs this
      @browser = browser(environment, test_name(scenario), 'default')
      $browser = @browser # only CirrusSearch needs this
      $session_id = @browser.driver.instance_variable_get(:@bridge).session_id
    end
  end
end

After do |scenario|
  if environment == :saucelabs
    sauce_api(%Q{{"passed": #{scenario.passed?}}})
    sauce_api(%Q{{"public": true}})
  end
  @browser.close unless ENV['KEEP_BROWSER_OPEN'] == 'true' or ENV['REUSE_BROWSER'] == 'true' # only CirrusSearch needs ENV['REUSE_BROWSER']
end
