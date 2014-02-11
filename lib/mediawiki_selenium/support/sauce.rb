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

require "cucumber/formatter/junit"

module Cucumber::Formatter
  class Sauce < Junit

    private

    def format_exception(exception)
      if $session_id
        sauce_job_page = "Sauce Labs job URL: http://saucelabs.com/jobs/#{$session_id}\n"
      else
        sauce_job_page = "Uh-oh. Could not find link to Sauce Labs job URL."
      end
      ([sauce_job_page] + ["#{exception.message} (#{exception.class})"] + exception.backtrace).join("\n")
    end
  end
end
