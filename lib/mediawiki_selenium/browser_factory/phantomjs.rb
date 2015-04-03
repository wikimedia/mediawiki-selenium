module MediawikiSelenium
  module BrowserFactory
    # Constructs new Phantomjs browser instances. The following configuration is
    # supported.
    #
    #  - browser_http_proxy
    #  - browser_language
    #  - browser_user_agent
    #
    # @see Base
    #
    class Phantomjs < Base
      configure(:browser_http_proxy) do |http_proxy, options|
        options[:desired_capabilities]['phantomjs.cli.args'] << "--proxy=#{http_proxy}"
      end

      configure(:browser_language) do |language, options|
        options[:desired_capabilities]['phantomjs.page.customHeaders.Accept-Language'] = language
      end

      configure(:browser_user_agent) do |user_agent, options|
        options[:desired_capabilities]['phantomjs.page.settings.userAgent'] = user_agent
      end

      protected

      def default_browser_options
        super.tap do |options|
          options[:desired_capabilities]['phantomjs.cli.args'] = []
        end
      end
    end
  end
end
