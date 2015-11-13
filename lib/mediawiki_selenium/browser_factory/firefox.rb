module MediawikiSelenium
  module BrowserFactory
    # Constructs new Firefox browser instances. The following configuration is
    # supported.
    #
    #  - browser_http_proxy
    #  - browser_language
    #  - browser_timeout
    #  - browser_user_agent
    #
    # @see Base
    #
    class Firefox < Base
      configure(:browser_http_proxy) do |http_proxy, options|
        options[:profile].proxy = Selenium::WebDriver::Proxy.new(http: http_proxy, ssl: http_proxy)
      end

      configure(:browser_timeout) do |timeout, options|
        timeout = timeout.to_i
        options[:profile]['dom.max_script_run_time'] = timeout
        options[:profile]['dom.max_chrome_script_run_time'] = timeout
      end

      configure(:browser_language) do |language, options|
        options[:profile]['intl.accept_languages'] = language
      end

      configure(:browser_user_agent) do |user_agent, options|
        options[:profile]['general.useragent.override'] = user_agent
      end

      protected

      def default_browser_options
        profile = Selenium::WebDriver::Firefox::Profile.new
        # Never show any firstrun pages.
        # @see http://kb.mozillazine.org/Browser.startup.homepage_override.mstone
        profile['browser.startup.homepage_override.mstone'] = 'ignore'
        super.merge(profile: profile)
      end
    end
  end
end
