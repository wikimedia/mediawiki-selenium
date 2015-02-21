require "cucumber/formatter/junit"

module Cucumber::Formatter
  class Sauce < Junit

    class << self
      attr_accessor :current_session_id
    end

    private

    def format_exception(exception)
      if ENV["HEADLESS"] == "true"
        job_url = ""
      elsif self.class.current_session_id
        job_url = "Sauce Labs job URL: http://saucelabs.com/jobs/#{self.class.current_session_id}\n"
      else
        job_url = "Uh-oh. Could not find link to Sauce Labs job URL."
      end

      msgs = [job_url] + ["#{exception.message} (#{exception.class})"] + exception.backtrace

      msgs.join("\n")
    end
  end
end
