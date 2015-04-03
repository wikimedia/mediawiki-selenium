module MediawikiSelenium
  module BrowserFactory
    # Constructs new Chrome browser instances. The following configuration is
    # supported.
    #
    #  - browser_http_proxy
    #  - browser_language
    #  - browser_user_agent
    #
    # @see Base
    #
    class Chrome < Base
      configure(:browser_http_proxy) do |http_proxy, options|
        options[:args] << "--proxy-server=#{http_proxy}"
      end

      configure(:browser_language) do |language, options|
        options[:prefs]['intl.accept_languages'] = language
      end

      configure(:browser_user_agent) do |user_agent, options|
        options[:args] << "--user-agent=#{user_agent}"
      end

      protected

      def default_browser_options
        super.merge(args: [], prefs: {})
      end
    end
  end
end
