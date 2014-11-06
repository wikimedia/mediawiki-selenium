require "watir-webdriver"

module MediawikiSelenium
  module BrowserFactory
    # Browser factories instantiate browsers of a certain type, configure
    # them according to bound environmental variables, and cache them
    # according to the uniqueness of that configuration.
    #
    class Base
      class << self
        # Binds environmental configuration to any browser created by
        # factories of this type. Use of this method should generally be
        # reserved for macro-style invocation in derived classes.
        #
        # @example Always configure Firefox's language according to `:browser_language`
        #   module MediawikiSelenium::BrowserFactory
        #     class Firefox < Base
        #       bind(:browser_language) do |language, options|
        #         options[:desired_capabilities][:firefox_profile]["intl.accept_languages"] = language
        #       end
        #     end
        #   end
        #
        # @param names [Symbol] One or more option names.
        #
        # @yield [values, browser_options] A block that binds the configuration to
        #                                  the browser options.
        #
        def bind(*names, &blk)
          raise ArgumentError, "no block given" unless block_given?

          key = names.length == 1 ? names.first : names
          default_bindings[key] ||= []
          default_bindings[key] << blk
        end

        # All bindings for this factory class combined with those of super
        # classes.
        #
        # @return [Hash]
        #
        def bindings
          if superclass <= Base
            default_bindings.merge(superclass.bindings) { |key, old, new| old + new }
          else
            default_bindings
          end
        end

        # Bindings for this factory class.
        #
        # @return [Hash]
        #
        def default_bindings
          @default_bindings ||= {}
        end
      end

      attr_reader :browser_name

      bind(:browser_timeout) { |value, options| options[:http_client].timeout = value.to_i }

      # Initializes new factory instances.
      #
      # @param browser_name [Symbol]
      #
      def initialize(browser_name)
        @browser_name = browser_name
        @bindings = {}
        @browser_cache = {}
      end

      # Returns a unique set of all the binding keys.
      #
      # @return [Array]
      #
      def all_binding_keys
        bindings.keys.flatten.uniq
      end

      # Binds environmental configuration to any browser created by this
      # factory instance.
      #
      # @example Override the user agent according :browser_user_agent
      #   factory = BrowserFactory.new(:firefox)
      #   factory.bind(:browser_user_agent) do |agent, options|
      #     options[:desired_capabilities][:firefox_profile]["general.useragent.override"] = agent
      #   end
      #
      # @example Annotate the session with our build information
      #   factory.bind(:job_name, :build_number) do |job, build, options|
      #     options[:desired_capabilities][:name] = "#{job} (#{build})"
      #   end
      #
      # @example Bindings aren't invoked unless all given options are configured
      #   factory.bind(:foo, :bar) do |foo, bar, options|
      #     # this never happens!
      #     options[:desired_capabilities][:name] = "#{foo} #{bar}"
      #   end
      #   factory.browser_for(Environment.new(foo: "x"))
      #
      # @param names [Symbol] One or more option names.
      #
      # @yield [values, browser_options] A block that binds the configuration to
      #                                  the browser options.
      #
      def bind(*names, &blk)
        key = names.length == 1 ? names.first : names
        @bindings[key] ||= []
        @bindings[key] << (blk || proc {})
      end

      # Effective bindings for this factory, those defined at the class level
      # and those defined for this instance.
      #
      # @return [Hash]
      #
      def bindings
        self.class.bindings.merge(@bindings) { |key, old, new| old + new }
      end

      # Instantiate a browser using the given environmental configuration.
      # Browsers are cached and reused as long as the configuration is the
      # same.
      #
      # @param config [Hash] Browser configuration.
      #
      # @return [Watir::Browser]
      #
      # @see #new_browser_for
      #
      def browser_for(config)
        @browser_cache[config] ||= new_browser_for(config)
      end

      # Browser options for the given configuration.
      #
      # @param config [Hash]
      #
      # @return [Hash]
      #
      def browser_options(config)
        options = default_browser_options.tap do |default_options|
          bindings.each do |(names, bindings_for_option)|
            bindings_for_option.each do |binding|
              values = config.values_at(*Array(names))

              unless values.any? { |value| value.nil? || value.to_s.empty? }
                binding.call(*values, default_options)
              end
            end
          end
        end

        finalize_options!(options)

        options
      end

      # Iterate over each browser created by this factory.
      #
      # @yield [browser]
      #
      def each(&blk)
        @browser_cache.values.each(&blk)
      end

      # A new browser for the given environmental configuration.
      #
      # @param config [Hash] Browser configuration.
      #
      # @return [Watir::Browser]
      #
      # @see #browser_for
      #
      def new_browser_for(config)
        new_browser(browser_options(config))
      end

      # Executes additional teardown tasks.
      #
      # @param env [Environment] Environment.
      # @param status [Symbol] Status of the executed scenario.
      #
      def teardown(env, status)
        # abstract
      end

      protected

      def default_browser_options
        { http_client: http_client, desired_capabilities: desired_capabilities }
      end

      def desired_capabilities
        Selenium::WebDriver::Remote::Capabilities.send(browser_name)
      end

      def finalize_options!(options)
        # abstract
      end

      def http_client
        Selenium::WebDriver::Remote::Http::Default.new
      end

      def new_browser(options)
        Watir::Browser.new(options[:desired_capabilities].browser_name, options)
      end
    end
  end
end
