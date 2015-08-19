require 'cucumber/formatter/junit'
require 'mediawiki_selenium/remote_browser_factory'

module Cucumber::Formatter
  class Sauce < Junit
    private

    def format_exception(exception)
      sids = MediawikiSelenium::RemoteBrowserFactory.last_session_ids

      if sids.nil? || sids.empty?
        message = 'Uh-oh. Could not find link to Sauce Labs job URL.'
      else
        message = sids.map { |sid| "Sauce Labs job URL: http://saucelabs.com/jobs/#{sid}\n" }.join
      end

      msgs = [message] + ["#{exception.message} (#{exception.class})"] + exception.backtrace

      msgs.join("\n")
    end
  end
end
