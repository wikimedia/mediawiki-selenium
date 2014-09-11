module MediawikiSelenium
  # Provides an abstraction layer between the environmental configuration and
  # step definitions.
  #
  class Environment
    include Comparable

    class ConfigurationError < StandardError
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def to_s
        "missing configuration for #{name}"
      end
    end

    CORE_BROWSER_OPTIONS = [
      :mediawiki_url,
      :mediawiki_user,
    ]

    REQUIRED_CONFIG = [
      :browser,
      :mediawiki_api_url,
      :mediawiki_password,
      :mediawiki_url,
      :mediawiki_user,
    ]

    attr_reader :config

    def initialize(config)
      @config = normalize_config(config)
      @factory_cache = {}
    end

    def initialize_clone(other)
      @config = other.config.clone
    end

    # Two environments are considered equal if they have identical
    # configuration.
    #
    def ==(other)
      @config == other.config
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

    # Binds new possible configuration for the given browser.
    #
    # @param browser_name [Symbol] Browser name.
    # @param option_name [Symbol] Option name.
    #
    # @yield []
    #
    def bind(browser_name, option_name, &blk)
      browser_factory(browser_name).bind(option_name, &blk)
    end

    # Browser with which to drive tests.
    #
    # @return [Watir::Browser]
    #
    def browser
      browser_factory.browser_for(self)
    end

    def browser_factory(type = browser_name)
      type = type.to_s.downcase.to_sym

      @factory_cache[type] ||= BrowserFactory.new(type).tap do |factory|
        CORE_BROWSER_OPTIONS.each { |name| factory.bind(name) }
      end
    end

    # Name of the browser we're using.
    #
    # @return [Symbol]
    #
    def browser_name
      lookup(:browser).downcase.to_sym
    end

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

    # Yields a new environment using the alternative versions of the given
    # configuration options. The alternative values are resolved by looking up
    # options that correspond to the given ones but have the given ID
    # appended.
    #
    # @example Overwrite :option with the value from :option_b
    #   # given an environment with { option: "x", option_b: "y", ... }
    #   env.with_alternative(:option, :b) do |env|
    #     env # => { option: "y", ... }
    #   end
    #
    # @example Overwrite both :option and :other with :option_b and :other_b
    #   # given { option: "x", option_b: "y", other: "w", other_b: "z" }
    #   env.with_alternative([:option, :other], :b) do |env|
    #     env # => { option: "y", other: "z", ... }
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
