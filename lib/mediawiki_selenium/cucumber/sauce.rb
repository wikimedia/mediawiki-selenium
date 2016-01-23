require 'cucumber/formatter/junit'
require 'mediawiki_selenium/remote_browser_factory'
require 'set'

module Cucumber::Formatter
  class Sauce < Junit
    def before_steps(_steps)
      @sids = Set.new

      super
    end

    def embed(session_id, mime, _label)
      return unless mime == 'application/vnd.webdriver-session-id'

      @sids << session_id
    end

    private

    def format_exception(exception)
      if @sids.nil? || @sids.empty?
        message = 'Uh-oh. Could not find link to Sauce Labs job URL.'
      else
        message = @sids.map { |sid| "Sauce Labs job URL: http://saucelabs.com/jobs/#{sid}\n" }.join
      end

      msgs = [message] + ["#{exception.message} (#{exception.class})"] + exception.backtrace

      msgs.join("\n")
    end
  end
end
