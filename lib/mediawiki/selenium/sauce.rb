=begin
This file is subject to the license terms in the LICENSE file found in the
mediawiki-selenium top-level directory and at
https://github.com/zeljkofilipin/mediawiki-selenium/blob/master/LICENSE. No part of
mediawiki-selenium, including this file, may be copied, modified, propagated, or
distributed except according to the terms contained in the LICENSE file.
Copyright 2013 by the Mediawiki developers. See the CREDITS file in the
mediawiki-selenium top-level directory and at
https://github.com/zeljkofilipin/mediawiki-selenium/blob/master/CREDITS.
=end

require 'cucumber/formatter/junit'

module Cucumber::Formatter
  class Sauce < Junit
    def format_exception(exception)
      sauce_job_page = "Sauce Labs job URL: http://saucelabs.com/jobs/#{$session_id}\n"
      ([sauce_job_page] + ["#{exception.message} (#{exception.class})"] + exception.backtrace).join("\n")
    end
  end
end
