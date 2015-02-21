require "cucumber/formatter/junit"

module Cucumber::Formatter
  class Sauce < Junit

    private

    def format_exception(exception)
      if ENV["HEADLESS"] == "true"
        sauce_job_page = ""
      elsif $session_id
        sauce_job_page = "Sauce Labs job URL: http://saucelabs.com/jobs/#{$session_id}\n"
      else
        sauce_job_page = "Uh-oh. Could not find link to Sauce Labs job URL."
      end

      msgs = [sauce_job_page] + ["#{exception.message} (#{exception.class})"] + exception.backtrace

      msgs.join("\n")
    end
  end
end
