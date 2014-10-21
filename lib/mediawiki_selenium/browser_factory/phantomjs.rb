module MediawikiSelenium
  module BrowserFactory
    class Phantomjs < Base
      bind(:browser_language) do |language, opts|
        opts[:desired_capabilities]["phantomjs.page.customHeaders.Accept-Language"] = language
      end

      bind(:browser_user_agent) do |user_agent, opts|
        opts[:desired_capabilities]["phantomjs.page.settings.userAgent"] = user_agent
      end
    end
  end
end
