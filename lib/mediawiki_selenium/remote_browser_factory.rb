require "uri"

module MediawikiSelenium
  # Constructs remote browser sessions to be run via Sauce Labs. Adds the
  # following configuration bindings to the factory.
  #
  #  - sauce_ondemand_username
  #  - sauce_ondemand_access_key
  #  - platform
  #  - version
  #
  module RemoteBrowserFactory
    REQUIRED_CONFIG = [:sauce_ondemand_username, :sauce_ondemand_access_key]
    URL = "http://ondemand.saucelabs.com/wd/hub"

    class << self
      def extend_object(factory)
        factory.bind(:sauce_ondemand_username, :sauce_ondemand_access_key) do |user, key, options|
          options[:url] = URI.parse(URL)

          options[:url].user = user
          options[:url].password = key
        end

        factory.bind(:platform) do |platform, options|
          options[:desired_capabilities].platform = platform
        end

        factory.bind(:version) do |version, options|
          options[:desired_capabilities].version = version
        end
      end
    end

    protected

    def new_browser(options)
      Watir::Browser.new(:remote, options)
    end
  end
end
