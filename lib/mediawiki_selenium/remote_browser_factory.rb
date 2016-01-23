require 'rest_client'
require 'uri'

module MediawikiSelenium
  # Constructs remote browser sessions to be run via Sauce Labs. Adds the
  # following configuration bindings to the factory.
  #
  #  - sauce_ondemand_username
  #  - sauce_ondemand_access_key
  #  - platform
  #  - version
  #  - device_name
  #  - device_orientation
  #
  module RemoteBrowserFactory
    REQUIRED_CONFIG = [:sauce_ondemand_username, :sauce_ondemand_access_key]
    URL = 'http://ondemand.saucelabs.com/wd/hub'

    def self.extend_object(base)
      return if base.is_a?(self)

      super

      base.configure(:sauce_ondemand_username, :sauce_ondemand_access_key) do |user, key, options|
        options[:url] = URI.parse(URL)

        options[:url].user = user
        options[:url].password = key
      end

      base.configure(:platform) do |platform, options|
        options[:desired_capabilities].platform = platform
      end

      base.configure(:version) do |version, options|
        options[:desired_capabilities].version = version
      end

      base.configure(:device_name) do |device_name, options|
        options[:desired_capabilities]['deviceName'] = device_name
      end

      base.configure(:device_orientation) do |device_orientation, options|
        options[:desired_capabilities]['deviceOrientation'] = device_orientation
      end
    end

    # Submits status and Jenkins build info to Sauce Labs.
    #
    def teardown(env, status)
      artifacts = super

      each do |browser|
        sid = browser.driver.session_id
        username = env.lookup(:sauce_ondemand_username)
        key = env.lookup(:sauce_ondemand_access_key)

        RestClient::Request.execute(
          method: :put,
          url: "https://saucelabs.com/rest/v1/#{username}/jobs/#{sid}",
          user: username,
          password: key,
          headers: { content_type: 'application/json' },
          payload: {
            public: true,
            passed: status == :passed,
            build: env.lookup(:build_number, default: nil)
          }.to_json
        )

        artifacts["http://saucelabs.com/jobs/#{sid}"] = 'text/url'
      end

      artifacts
    end

    protected

    def finalize_options!(options)
      case @browser_name
      when :firefox
        options[:desired_capabilities][:firefox_profile] = options.delete(:profile)
      when :chrome
        options[:desired_capabilities]['chromeOptions'] ||= {}
        options[:desired_capabilities]['chromeOptions']['prefs'] = options.delete(:prefs)
        options[:desired_capabilities]['chromeOptions']['args'] = options.delete(:args)
      end
    end

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
