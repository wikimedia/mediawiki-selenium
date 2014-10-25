module MediawikiSelenium
  module BrowserFactory
    # Constructs new Firefox browser instances. The following configuration is
    # supported.
    #
    #  - browser_language
    #  - browser_timeout
    #  - browser_user_agent
    #
    class Firefox < Base

      bind(:browser_timeout) do |timeout, opts|
        timeout = timeout.to_i
        opts[:desired_capabilities][:firefox_profile]["dom.max_script_run_time"] = timeout
        opts[:desired_capabilities][:firefox_profile]["dom.max_chrome_script_run_time"] = timeout
      end

      bind(:browser_language) do |language, opts|
        opts[:desired_capabilities][:firefox_profile]["intl.accept_languages"] = language
      end

      bind(:browser_user_agent) do |user_agent, opts|
        opts[:desired_capabilities][:firefox_profile]["general.useragent.override"] = user_agent
      end

      protected

      def desired_capabilities
        super.tap do |capabilities|
          capabilities[:firefox_profile] = Selenium::WebDriver::Firefox::Profile.new
        end
      end
    end
  end
end
