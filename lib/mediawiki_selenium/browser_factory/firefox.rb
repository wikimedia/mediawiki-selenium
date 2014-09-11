module MediawikiSelenium
  module BrowserFactory
    class Firefox < Base
      bind(:browser_timeout) do |timeout, opts|
        timeout = timeout.to_i
        opts[:desired_capabilities][:firefox_profile]["dom.max_script_run_time"] = timeout
        opts[:desired_capabilities][:firefox_profile]["dom.max_chrome_script_run_time"] = timeout
      end

      def capabilities
        super.tap do |capabilities|
          capabilities[:firefox_profile] = Selenium::WebDriver::Firefox::Profile.new
        end
      end

      def profile
        Selenium::WebDriver::Firefox::Profile.new.tap do |profile|
          bind(:browser_timeout) do |timeout|
            profile["dom.max_script_run_time"] = timeout
            profile["dom.max_chrome_script_run_time"] = timeout
          end

          bind(:browser_language) do |language|
            profile["intl.accept_languages"] = language
          end

          bind(:browser_user_agent) do |user_agent|
            profile["general.useragent.override"] = user_agent
          end
        end
      end
    end
  end
end
