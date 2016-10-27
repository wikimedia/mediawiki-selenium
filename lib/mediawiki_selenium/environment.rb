require 'yaml'

module MediawikiSelenium
  # Provides an interface that unifies environmental configuration, page
  # objects, and browser setup. Additionally, it provides a DSL for switching
  # between user/wiki/browser contexts in ways that help to decouple test
  # implementation from the target wikis.
  #
  # Default configuration for various resources (wiki URLs, users, etc.) is
  # typically loaded from an `environments.yml` YAML file in the current
  # working directory. It should contain defaults for each environment in
  # which the tests are expected to run, indexed by environment name.
  #
  #     beta:
  #       mediawiki_url: http://en.wikipedia.beta.wmflabs.org/wiki/
  #       mediawiki_user: Selenium_user
  #     test2:
  #       mediawiki_url: http://test2.wikipedia.org/wiki/
  #       mediawiki_user: Selenium_user
  #
  # Which default set to use is determined by the value of the
  # `MEDIAWIKI_ENVIRONMENT` environment variable, or an entry called "default"
  # if none is set. (See {load} and {load_default}.) The easiest way to
  # designate such a default set is to use a YAML anchor like so.
  #
  #     beta: &default
  #       mediawiki_url: http://en.wikipedia.beta.wmflabs.org/wiki/
  #       mediawiki_user: Selenium_user
  #     test2:
  #       mediawiki_url: http://test2.wikipedia.org/wiki/
  #       mediawiki_user: Selenium_user
  #     default: *default
  #
  # Any additional configuration specified via environment variables overrides
  # what is specified in the YAML file. For example, the following would use
  # the default configuration as specified under `beta` in the YAML file but
  # define `mediawiki_user` as `Other_user` instead of `Selenium_user`.
  #
  #     export MEDIAWIKI_ENVIRONMENT=beta MEDIAWIKI_USER=Other_user
  #     bundle exec cucumber ...
  #
  # There are various methods that allow you to perform actions in the context
  # of some alternative resource, for example as a different user using
  # {#as_user}, or on different wiki using {#on_wiki}. Instead of referencing
  # the exact user names or URLs for these resources, you reference them by an
  # ID which corresponds to configuration made in `environments.yml`.
  #
  #     # environments.yml:
  #     beta:
  #       # ...
  #       mediawiki_user_b: Selenium_user2
  #
  #     # step definition:
  #     Given(/^user B has linked to a page I created$/) do
  #       as_user(:b) { api.create_page(...) }
  #     end
  #
  # This level of abstraction is intended to reduce coupling between tests
  # and test environments, and should promote step definitions that are more
  # readable and congruent with the natural-language steps they implement.
  #
  class Environment
    include Comparable

    class << self
      attr_accessor :default_configuration, :default_test_directory

      # Instantiates a new environment using the given set of default
      # configuration from `environments.yml` in the current working
      # directory, and the additional hash of environment variables.
      #
      # @param name [String] Name of the environment.
      # @param extra [Hash] Additional configuration to use.
      # @param test_dir [String] Path from which to search upward for
      # `environments.yml`
      #
      def load(name, extra = {}, test_dir = nil)
        name = name.to_s
        configs = []

        unless name.empty?
          envs = YAML.load_file(search_for_configuration(test_dir || default_test_directory))
          raise ConfigurationError, "unknown environment `#{name}`" unless envs.include?(name)
          configs << envs[name]
        end

        configs << extra

        env = new(*configs)
        env
      end

      # Instantiates a new environment from the values of `ENV` and the
      # default configuration corresponding to `ENV["MEDIAWIKI_ENVIRONMENT"]`,
      # if one is defined.
      #
      # @see load
      #
      def load_default(test_dir = nil)
        load(ENV['MEDIAWIKI_ENVIRONMENT'] || 'default', ENV, test_dir)
      end

      # Searches for `environments.yml` in the given path. If it isn't found,
      # the search continues upward in the directory hierarchy.
      #
      # @param path [String] Path to search for configuration
      #
      # @return [String] Qualified path to the configuration file
      #
      def search_for_configuration(path)
        return default_configuration if path.nil? || path.empty? || path == '.'

        file_path = File.join(path, default_configuration)
        return file_path if File.exist?(file_path)

        search_for_configuration(File.dirname(path))
      end
    end

    self.default_configuration = 'environments.yml'
    self.default_test_directory = 'tests/browser'

    def initialize(*configs)
      @_config = configs.map { |config| normalize_config(config) }.reduce(:merge)
      @_factory_cache = {}
      @_current_alternatives = {}

      extend(HeadlessHelper) if headless?
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
    # @example
    #   Given(/^user B has linked to a page I created$/) do
    #     as_user(:b) { api.create_page(...) }
    #   end
    #
    # @param id [Symbol] Alternative user ID.
    #
    # @yield [user, password]
    # @yieldparam user [String] Alternative MediaWiki user.
    # @yieldparam password [String] Alternative MediaWiki password.
    #
    def as_user(id, &blk)
      record_alternatives([:mediawiki_user, :mediawiki_password], id) do
        with(mediawiki_user: user(id), mediawiki_password: password(id), &blk)
      end
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
        factory.configure(:_browser_session)
        factory.extend(RemoteBrowserFactory) if remote?
      end
    end

    # Name of the browser we're using. If the `:browser` configuration
    # contains a version at the end, only the name is returned.
    #
    # @example
    #   env = Environment.new(browser: 'internet_explorer 8.0')
    #   env.browser_name # => :internet_explorer
    #
    # @return [Symbol]
    #
    def browser_name
      browser_spec[0].to_sym
    end

    # Tag names that can be used to filter test scenarios for a specific
    # browser and/or version.
    #
    # @return [Array<String>]
    #
    def browser_tags
      tags = [browser_name.to_s]

      version = browser_version
      tags << "#{browser_name}_#{version}" if version

      tags
    end

    # Version of the browser we're using. If a `:version` configuration
    # is provided, that value is returned. Otherwise a version is searched for
    # in the `:browser` configuration.
    #
    # @return [String]
    #
    def browser_version
      lookup(:version, default: browser_spec[1])
    end

    # Returns the current alternate ID for the given configuration key.
    #
    # @param key [Symbol] Configuration key.
    #
    def current_alternative(key)
      @_current_alternatives[key]
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

    # Whether this environment is configured to run in headless mode (using
    # Xvfb via the headless gem).
    #
    # @return [true, false]
    #
    def headless?
      lookup(:headless, default: 'false').to_s == 'true'
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
    def in_browser(id, overrides = {}, &blk)
      overrides = overrides.each.with_object({}) do |(name, value), hash|
        hash["browser_#{name}".to_sym] = value
      end

      with(overrides.merge(_browser_session: id), &blk)
    end

    # Whether browsers should be left open after each scenario completes.
    #
    def keep_browser_open?
      lookup(:keep_browser_open, default: 'false') == 'true'
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
    # @return [Hash{Symbol => String}]
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
      lookup(:mediawiki_password, id: id, default: -> { lookup(:mediawiki_password) })
    end

    # Whether this environment has been configured to use remote browser
    # sessions.
    #
    # @return [Boolean]
    #
    def remote?
      RemoteBrowserFactory::REQUIRED_CONFIG.all? { |name| lookup(name, default: false) }
    end

    # Executes setup tasks, annotating the Selenium session with any
    # configured `job_name` and `build_number`.
    #
    # Additional helpers may perform their own tasks by implementing this
    # method.
    #
    # @example Setup the environment before each scenario starts
    #   Before do |scenario|
    #     setup(name: scenario.name)
    #   end
    #
    # @param info [Hash] Hash of test case information.
    #
    def setup(info = {})
      browser_factory.configure do |options|
        options[:desired_capabilities][:name] = info[:name] || 'scenario'
      end

      browser_factory.configure(:job_name) do |job, options|
        options[:desired_capabilities][:name] += " #{job}"
      end

      browser_factory.configure(:build_number) do |build, options|
        options[:desired_capabilities][:name] += "##{build}"
      end
    end

    # Executes teardown tasks including instructing all browser factories to
    # close any open browsers and perform their own teardown tasks.
    #
    # Teardown tasks may produce artifacts, which will be returned in the form
    # `{ path => mime_type }`.
    #
    # @example Teardown environment resources after each scenario completes
    #   After do |scenario|
    #     artifacts = teardown(name: scenario.name, status: scenario.status)
    #     artifacts.each { |path, mime_type| embed(path, mime_type) }
    #   end
    #
    # @param info [Hash] Hash of test case information.
    #
    # @yield [browser]
    # @yieldparam browser [Watir::Browser] Browser object, before it's closed.
    #
    # @return [Hash{String => String}] Hash of path/mime-type artifacts.
    #
    def teardown(info = {})
      artifacts = {}

      @_factory_cache.each do |(_, browser_name), factory|
        factory.each do |browser|
          yield browser if block_given?
          browser.close unless keep_browser_open? && browser_name != :phantomjs
        end

        factory_artifacts = factory.teardown(self, info[:status] || :passed)
        artifacts.merge!(factory_artifacts) if factory_artifacts.is_a?(Hash)
      end

      artifacts
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
      user(id).gsub('_', ' ')
    end

    # Navigates the current browser to the given wiki.
    #
    # @param id [Symbol] Alternative wiki ID.
    #
    # @yield [url]
    # @yieldparam url [String] Wiki URL.
    #
    def visit_wiki(id = nil)
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
    #   env.wiki_url # => "http://an.example/wiki/"
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
        if path.include?(':')
          path_uri = URI.parse(path)
          path = "./#{path}" if path_uri.class == URI::Generic && !path.start_with?('/')
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
    def with_alternative(names, id, &blk)
      names = Array(names)
      record_alternatives(names, id) { with(lookup_all(names, id: id), &blk) }
    end

    protected

    def config
      @_config
    end

    private

    def browser_config
      config = lookup_all(browser_factory.all_binding_keys, default: nil).reject { |_k, v| v.nil? }

      # The browser version may be provided as part of the `:browser`
      # configuration or separately as `:version`. In either case,
      # `browser_version` will return the right value.
      version = browser_version
      config[:version] = version unless version.nil?

      config
    end

    def browser_spec
      lookup(:browser, default: 'firefox').to_s.downcase.split(' ')
    end

    def normalize_config(hash)
      hash.each.with_object({}) { |(k, v), acc| acc[normalize_key(k)] = v }
    end

    def normalize_key(key)
      key.to_s.downcase.to_sym
    end

    def record_alternatives(names, id)
      original_alts = @_current_alternatives.dup
      @_current_alternatives.merge!(names.each.with_object({}) { |n, alts| alts[n] = id })
      yield
    ensure
      @_current_alternatives = original_alts
    end

    def with(overrides = {})
      overrides = normalize_config(overrides)
      original_config = @_config.dup

      begin
        @_config = @_config.merge(overrides)
        yield(*overrides.values) if block_given?
      ensure
        @_config = original_config
      end
    end
  end
end
