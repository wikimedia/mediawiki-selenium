module MediawikiSelenium
  # Provides an interface that unifies environmental configuration, page
  # objects, and browser setup. Additionally, it provides grammars for
  # switching between user/wiki/browser contexts in ways that help promote
  # decouple test implementation.
  #
  class Environment
    include Comparable

    REQUIRED_CONFIG = [
      :browser,
      :mediawiki_api_url,
      :mediawiki_password,
      :mediawiki_url,
      :mediawiki_user,
    ]

    attr_reader :config
    protected :config

    def initialize(config)
      @config = normalize_config(config)
      @factory_cache = {}
    end

    def initialize_clone(other)
      @config = other.config.clone
    end

    # Whether the given environment is equal to this one. Two environments are
    # considered equal if they have identical configuration.
    #
    # @param other [Environment]
    #
    # @return [Boolean]
    #
    def ==(other)
      @config == other.config
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
    # @yield [env]
    # @yieldparam env [Environment] Environment
    #
    # @return [Environment]
    #
    def as_user(id, &blk)
      with_alternative([:mediawiki_user, :mediawiki_password], id, &blk)
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

      @factory_cache[[remote?, browser]] ||= BrowserFactory.new(browser).tap do |factory|
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
    # @yield [env]
    # @yieldparam env [Environment] Environment
    #
    # @return [Environment]
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
      lookup(:keep_browser_open) == "true"
    end

    # Returns the configured value for the given env variable name.
    #
    # @param key [Symbol] Environment variable name.
    # @param id [Symbol] Alternative variable suffix.
    #
    # @return [String]
    #
    def lookup(key, id = nil)
      key = "#{key}_#{id}" unless id.nil?
      key = key.to_sym
      value = @config[key]

      if value.nil? || value.to_s.empty?
        if id.nil?
          if REQUIRED_CONFIG.include?(key)
            raise ConfigurationError, key
          else
            nil
          end
        else
          lookup(key)
        end
      else
        value
      end
    end

    # Returns the configured values for the given env variable names.
    #
    # @param keys [Array<Symbol>] Environment variable names.
    # @param id [Symbol] Alternative variable suffix.
    #
    # @return [Array<String>]
    #
    def lookup_all(keys, id = nil)
      keys.each.with_object({}) do |key, hash|
        value = lookup(key, id)
        hash[key] = value unless value.nil?
      end
    end

    # Executes the given block within the context of an environment that's
    # using the given alternative wiki URL and its corresponding API endpoint.
    #
    # @param id [Symbol] Alternative wiki ID.
    #
    # @yield [env]
    # @yieldparam env [Environment] Environment
    #
    # @return [Environment]
    #
    def on_wiki(id, &blk)
      with_alternative([:mediawiki_url, :mediawiki_api_url], id, &blk)
    end

    # Whether this environment has been configured to use remote browser
    # sessions.
    #
    # @return [Boolean]
    #
    def remote?
      RemoteBrowserFactory::REQUIRED_CONFIG.all? { |name| lookup(name) }
    end

    # Executes teardown tasks including instructing all browser factories to
    # close any open browsers and perform their own teardown tasks.
    #
    # @example Teardown environment resources after each scenario completes
    #   After do
    #     teardown(scenario.passed?)
    #   end
    #
    # @param status [Symbol] Status of the executed scenario.
    #
    def teardown(status = :passed)
      @factory_cache.each do |_, factory|
        factory.each { |browser| browser.close } unless keep_browser_open?
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

    # Navigates the current browser to the given wiki.
    #
    # @param id [Symbol] Alternative wiki ID.
    #
    # @yield [env]
    # @yieldparam env [Environment] Environment
    #
    # @return [Environment]
    #
    def visit_wiki(id, &blk)
      on_wiki(id) do |env|
        browser.goto env.wiki_url
        blk.call(env) unless blk.nil?
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

    # Yields a new environment using the alternative versions of the given
    # configuration options. The alternative values are resolved by looking up
    # options that correspond to the given ones but have the given ID
    # appended.
    #
    # @example Overwrite :foo with the :b alternative
    #   # given an environment with { foo: "x", foo_b: "y", ... }
    #   env.with_alternative(:foo, :b) do |env|
    #     env # => { foo: "y", ... }
    #   end
    #
    # @example Overwrite both :foo and :bar with the :b alternatives
    #   # given { foo: "x", foo_b: "y", bar: "w", bar_b: "z" }
    #   env.with_alternative([:foo, :bar], :b) do |env|
    #     env # => { foo: "y", bar: "z", ... }
    #   end
    #
    # @param names [Array|Symbol] Configuration option or options.
    # @param id [Symbol] Alternative user ID.
    #
    # @yield [env]
    # @yieldparam env [Environment] The modified environment.
    #
    # @return [Environment] The modified environment.
    #
    def with_alternative(names, id, &blk)
      with(lookup_all(Array(names), id), &blk)
    end

    private

    def browser_config
      lookup_all(browser_factory.all_binding_keys)
    end

    def normalize_config(hash)
      hash.each.with_object({}) { |(k, v), acc| acc[k.to_s.downcase.to_sym] = v }
    end

    def with(overrides = {})
      clone.tap do |env|
        env.config.merge!(normalize_config(overrides))
        yield env
      end
    end
  end
end
