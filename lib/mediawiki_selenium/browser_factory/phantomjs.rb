module MediawikiSelenium
  module BrowserFactory
    class Phantomjs < Base
      def capabilities
        super.tap do |capabilities|
          bind(:browser_language) do |language|
            capabilities["phantomjs.page.customHeaders.Accept-Language"] = language
          end

          bind(:browser_user_agent) do |user_agent|
            capabilities["phantomjs.page.settings.userAgent"] = user_agent
          end
        end
      end
    end
  end
end
