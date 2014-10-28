require "rest_client"
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
        return if factory.is_a?(self)

        super

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

    # Submits status and Jenkins build info to Sauce Labs.
    #
    def teardown_for(env, status)
      each do |browser|
        sid = browser.driver.session_id
        url = URI.parse(browser.driver.http.server_url)
        username = url.user
        key = url.password

        RestClient::Request.execute(
          method: :put,
          url: "https://saucelabs.com/rest/v1/#{username}/jobs/#{sid}",
          user: username,
          password: key,
          headers: { content_type: "application/json" },
          payload: {
            public: true,
            passed: status == :passed,
            build: env.lookup(:build_number),
          }.to_json
        )
      end
    end

    protected

    def new_browser(options)
      Watir::Browser.new(:remote, options).tap do |browser|
        browser.driver.file_detector = lambda do |args|
          # args => ["/path/to/file"]
          str = args.first.to_s
          str if File.exist?(str)
        end
      end
    end
  end
end
