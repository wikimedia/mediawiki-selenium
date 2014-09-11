module MediawikiSelenium
  module BrowserFactory
    class Chrome < Base
      def arguments
        [].tap do |args|
          bind(:browser_user_agent) do |user_agent|
            args << "--user-agent=#{user_agent}"
          end
        end
      end

      def capabilities
        super.merge(
          "chrome.profile" => profile.as_json["zip"],
          "chromeOptions" => { "args" => arguments },
        )
      end

      def profile
        Selenium::WebDriver::Chrome::Profile.new.tap do |profile|
          bind(:browser_language) do |language|
            profile["intl.accept_languages"] = language
          end
        end
      end
    end
  end
end
