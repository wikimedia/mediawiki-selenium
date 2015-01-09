module MediawikiSelenium
  module BrowserFactory
    # Constructs new Firefox browser instances. The following configuration is
    # supported.
    #
    #  - browser_language
    #  - browser_timeout
    #  - browser_user_agent
    #
    # @see Base
    #
    class Firefox < Base
      bind(:browser_timeout) do |timeout, options|
        timeout = timeout.to_i
        options[:profile]["dom.max_script_run_time"] = timeout
        options[:profile]["dom.max_chrome_script_run_time"] = timeout
      end

      bind(:browser_language) do |language, options|
        options[:profile]["intl.accept_languages"] = language
      end

      bind(:browser_user_agent) do |user_agent, options|
        options[:profile]["general.useragent.override"] = user_agent
      end

      protected

      def default_browser_options
        super.merge(profile: Selenium::WebDriver::Firefox::Profile.new)
      end
    end
  end
end
