require "yaml"

module MediawikiSelenium
  # Provides an interface that unifies environmental configuration, page
  # objects, and browser setup. Additionally, it provides a DSL for switching
  # between user/wiki/browser contexts in ways that help to decouple test
  # implementation from the target wikis.
  #
  class Environment
    include Comparable

    class << self
      attr_accessor :default_configuration

      # Instantiates a new environment using the given set of default
      # configuration from `environments.yml` in the current working
      # directory, and the additional hash of environment variables.
      #
      # @param name [String] Name of the environment.
      # @param extra [Hash] Additional configuration to use.
      #
      def load(name, extra = {})
        name = name.to_s
        configs = []

        unless name.empty?
          envs = YAML.load_file(default_configuration)
          raise ConfigurationError, "unknown environment `#{name}`" unless envs.include?(name)
          configs << envs[name]
        end

        configs << extra

        new(*configs)
      end

      # Instantiates a new environment from the values of `ENV` and the
      # default configuration corresponding to `ENV["MEDIAWIKI_ENVIRONMENT"]`,
      # if one is defined.
      #
      # @see load
      #
      def load_default
        load(ENV["MEDIAWIKI_ENVIRONMENT"], ENV)
      end

    end

    self.default_configuration = "environments.yml"

    def initialize(*configs)
      @_config = configs.map { |config| normalize_config(config) }.reduce(:merge)
      @_factory_cache = {}
    end

    # Whether the given environment is equal to this one. Two environments are
    # considered equal if they have identical configuration.
    #
    # @param other [Environment]
    #
    # @return [Boolean]
    #
    def ==(other)
      config == other.config
    end

    # Returns the configured value for the given env variable name.
    #
    # @see #lookup
    #
    # @param key [Symbol] Environment variable name.
    #
    # @return [String]
    #
    def [](key)
      lookup(key)
    end

    # Executes the given block within the context of an environment that's
    # using the given alternative user and its password.
    #
    # @param id [Symbol] Alternative user ID.
    #
    # @yield [user, password]
    # @yieldparam user [String] Alternative MediaWiki user.
    # @yieldparam password [String] Alternative MediaWiki password.
    #
    # @return self
    #
    def as_user(id, &blk)
      with_alternative([:mediawiki_user, password_variable], id, &blk)
    end

    # Browser with which to drive tests.
    #
    # @return [Watir::Browser]
    #
    def browser
      browser_factory.browser_for(browser_config)
    end

    # Factory used to instantiate and open new browsers.
    #
    # @param browser [Symbol] Browser name.
    #
    # @return [BrowserFactory::Base]
    #
    def browser_factory(browser = browser_name)
      browser = browser.to_s.downcase.to_sym

      @_factory_cache[[remote?, browser]] ||= BrowserFactory.new(browser).tap do |factory|
        factory.bind(:_browser_session)
        factory.extend(RemoteBrowserFactory) if remote?
      end
    end

    # Name of the browser we're using.
    #
    # @return [Symbol]
    #
    def browser_name
      lookup(:browser).downcase.to_sym
    end

    # A reference to this environment. Can be used in conjunction with {#[]}
    # for syntactic sugar in looking up environment configuration where `self`
    # would otherwise seem ambiguous.
    #
    # @example
    #   Then(/^I see my username on the page$/) do
    #     expect(on(SomePage).html).to include(env[:mediawiki_user])
    #   end
    #
    # @return [self]
    #
    def env
      self
    end

    # Executes the given block within the context of an environment that uses
    # a unique browser session and possibly different configuration. Note that
    # any given configuration overrides are scoped with a `:browser_` prefix.
    #
    # @example Implement a "logged out" step following some authenticated one
    #   When(/^I do something while logged in$/) do
    #     in_browser(:a) do
    #       # perform action in logged in session
    #     end
    #   end
    #
    #   When(/^I do something else after logging out$/) do
    #     in_browser(:b) do
    #       # perform action in logged out session without actually logging
    #       # out since that would affect all auth sessions for the user
    #     end
    #   end
    #
    # @example Perform a subsequent step requiring a different browser language
    #   When(/^I visit the same page with my browser in Spanish$/) do |scenario, block|
    #     in_browser(:a, language: "es") do
    #       # test that it now serves up Spanish text
    #     end
    #   end
    #
    # @param id [Symbol] Browser session ID.
    # @param overrides [Hash] Browser configuration overrides.
    #
    # @yield [*args] Overridden browser configuration.
    #
    # @return self
    #
    def in_browser(id, overrides = {}, &blk)
      overrides = overrides.each.with_object({}) do |(name, value), hash|
        hash["browser_#{name}".to_sym] = value
      end

      with(overrides.merge(_browser_session: id), &blk)
    end

    # Whether browsers should be left open after each scenario completes.
    #
    def keep_browser_open?
      lookup(:keep_browser_open, default: "false") == "true"
    end

    # Returns the configured value for the given env variable name.
    #
    # @example Value of `:browser_language` and fail if it wasn't provided
    #   env.lookup(:browser_language)
    #
    # @example Value of `:browser_language` alternative `:b`
    #   env.lookup(:browser_language, id: :b)
    #
    # @example Value of `:browser_language` or try `:browser_lang`
    #   env.lookup(:browser_language, default: -> { env.lookup(:browser_lang) })
    #
    # @param key [Symbol] Environment variable name.
    # @param options [Hash] Options.
    # @option options [Symbol] :id Alternative ID.
    # @option options [Object, Proc] :default Default value or promise of a value.
    #
    # @return [String]
    #
    def lookup(key, options = {})
      key = "#{key}_#{options[:id]}" if options.fetch(:id, nil)
      key = normalize_key(key)

      value = config[key]

      if value.nil? || value.to_s.empty?
        if options.include?(:default)
          options[:default].is_a?(Proc) ? options[:default].call : options[:default]
        else
          raise ConfigurationError, "missing configuration for `#{key}`"
        end
      else
        value
      end
    end

    # Returns the configured values for the given env variable names.
    #
    # @param keys [Array<Symbol>] Environment variable names.
    # @param options [Hash] Options.
    # @option options [Symbol] :id Alternative ID.
    # @option options [Object] :default Default if no configuration is found.
    #
    # @return [Array<String>]
    #
    # @see #lookup
    #
    def lookup_all(keys, options = {})
      keys.each.with_object({}) do |key, hash|
        hash[key] = lookup(key, options)
      end
    end

    # Executes the given block within the context of an environment that's
    # using the given alternative wiki URL and its corresponding API endpoint.
    #
    # If no API URL is explicitly defined for the given alternative, one is
    # constructed relative to the wiki URL.
    #
    # @example Visit a random page on wiki B
    #   on_wiki(:b) { visit(RandomPage) }
    #
    # @param id [Symbol] Alternative wiki ID.
    #
    # @yield [wiki_url]
    # @yieldparam wiki_url [String] Alternative wiki URL.
    #
    # @return self
    #
    def on_wiki(id, &blk)
      with_alternative(:mediawiki_url, id, &blk)
    end

    # Returns the current value for `:mediawiki_password` or the value for the
    # given alternative.
    #
    # @param id [Symbol] Alternative user ID.
    #
    # @return [String]
    #
    def password(id = nil)
      lookup(password_variable, id: id)
    end

    # Whether this environment has been configured to use remote browser
    # sessions.
    #
    # @return [Boolean]
    #
    def remote?
      RemoteBrowserFactory::REQUIRED_CONFIG.all? { |name| lookup(name, default: false) }
    end

    # Executes teardown tasks including instructing all browser factories to
    # close any open browsers and perform their own teardown tasks.
    #
    # @example Teardown environment resources after each scenario completes
    #   After do
    #     teardown(scenario.status)
    #   end
    #
    # @param status [Symbol] Status of the executed scenario.
    #
    # @yield [browser]
    # @yieldparam browser [Watir::Browser] Browser object, before it's closed.
    #
    def teardown(status = :passed)
      @_factory_cache.each do |_, factory|
        factory.each do |browser|
          yield browser if block_given?
          browser.close unless keep_browser_open?
        end

        factory.teardown(self, status)
      end
    end

    # Returns a name from the given scenario.
    #
    # @param scenario [Cucumber::Ast::Scenario]
    #
    # @return [String]
    #
    def test_name(scenario)
      if scenario.respond_to? :feature
        "#{scenario.feature.title}: #{scenario.title}"
      elsif scenario.respond_to? :scenario_outline
        "#{scenario.scenario_outline.feature.title}: #{scenario.scenario_outline.title}: #{scenario.name}"
      else
        scenario.name
      end
    end

    # Returns the current value for `:mediawiki_user` or the value for the
    # given alternative.
    #
    # @param id [Symbol] Alternative user ID.
    #
    # @return [String]
    #
    def user(id = nil)
      lookup(:mediawiki_user, id: id)
    end

    # Returns the current user, or the one for the given alternative, with all
    # "_" replaced with " ".
    #
    # @param id [Symbol] Alternative user ID.
    #
    # @return [String]
    #
    def user_label(id = nil)
      user(id).gsub("_", " ")
    end

    # Navigates the current browser to the given wiki.
    #
    # @param id [Symbol] Alternative wiki ID.
    #
    # @yield [url]
    # @yieldparam url [String] Wiki URL.
    #
    # @return self
    #
    def visit_wiki(id)
      on_wiki(id) do |url|
        browser.goto url
        yield url if block_given?
      end
    end

    # Qualifies any given relative path using the configured `:mediawiki_url`.
    # Absolute URLs are left untouched.
    #
    # @example
    #   env = Environment.new(mediawiki_url: "http://an.example/wiki/")
    #
    #   env.wiki_url("page") # => "http://an.example/wiki/page"
    #   env.wiki_url("/page") # => "http://an.example/page"
    #   env.wiki_url("http://other.example") # => "http://other.example"
    #
    def wiki_url(path = nil)
      url = lookup(:mediawiki_url)

      if path
        # Prefixing relative paths with an explicit "./" guarantees proper
        # parsing of paths like "Special:Page" that would otherwise be
        # confused for URI schemes.
        if path.include?(":")
          path_uri = URI.parse(path)
          path = "./#{path}" if path_uri.class == URI::Generic && !path.start_with?("/")
        end

        url = URI.parse(url).merge(path).to_s
      end

      url
    end

    # Executes the given block within the context of a new environment
    # configured using the alternative versions of the given options. The
    # alternative configuration values are resolved using the given ID and
    # passed to the block as arguments.
    #
    # @example Overwrite :foo with the :b alternative
    #   # given an environment with config { foo: "x", foo_b: "y", ... }
    #   with_alternative(:foo, :b) do |foo|
    #     self # => #<Environment @config = { foo: "y", ... }>
    #     foo # => "y"
    #   end
    #
    # @example Overwrite both :foo and :bar with the :b alternatives
    #   # given an environment with config { foo: "x", foo_b: "y", bar: "w", bar_b: "z" }
    #   with_alternative([:foo, :bar], :b) do |foo, bar|
    #     self # => #<Environment @config = { foo: "y", bar: "z", ... }>
    #     foo # => "y"
    #     bar # => "z"
    #   end
    #
    # @param names [Symbol|Array<Symbol>] Configuration option or options.
    # @param id [Symbol] Alternative user ID.
    #
    # @yield [*args] Values of the overridden configuration.
    #
    # @return self
    #
    def with_alternative(names, id, &blk)
      with(lookup_all(Array(names), id: id), &blk)
    end

    protected

    def config
      @_config
    end

    private

    def browser_config
      lookup_all(browser_factory.all_binding_keys, default: nil).reject { |k, v| v.nil? }
    end

    def password_variable
      name = lookup(:mediawiki_password_variable, default: "")
      name.empty? ? :mediawiki_password : normalize_key(name)
    end

    def normalize_config(hash)
      hash.each.with_object({}) { |(k, v), acc| acc[normalize_key(k)] = v }
    end

    def normalize_key(key)
      key.to_s.downcase.to_sym
    end

    def with(overrides = {})
      overrides = normalize_config(overrides)
      original_config = @_config.dup

      begin
        @_config = @_config.merge(overrides)
        yield *overrides.values if block_given?
      ensure
        @_config = original_config
      end
    end
  end
end
