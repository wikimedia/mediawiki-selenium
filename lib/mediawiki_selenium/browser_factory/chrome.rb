module MediawikiSelenium
  module BrowserFactory
    class Chrome < Base
      bind(:browser_language) do |language, opts|
        opts[:desired_capabilities]["chromeOptions"]["profile"]["intl.accept_languages"] = language
      end

      bind(:browser_user_agent) do |user_agent, opts|
        opts[:desired_capabilities]["chromeOptions"]["args"] << "--user-agent=#{user_agent}"
      end

      protected

      def capabilities
        super.tap do |capabilities|
          capabilities["chromeOptions"] = {
            "args" => [],
            "profile" => Selenium::WebDriver::Chrome::Profile.new,
          }
        end
      end

      def finalize_options(options)
        options[:desired_capabilities]["chromeOptions"].tap do |options|
          options["profile"] = options["profile"].as_json["zip"]
        end
      end
    end
  end
end
