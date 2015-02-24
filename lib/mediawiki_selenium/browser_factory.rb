module MediawikiSelenium
  module BrowserFactory
    autoload :Base, 'mediawiki_selenium/browser_factory/base'
    autoload :Firefox, 'mediawiki_selenium/browser_factory/firefox'
    autoload :Chrome, 'mediawiki_selenium/browser_factory/chrome'
    autoload :Phantomjs, 'mediawiki_selenium/browser_factory/phantomjs'

    # Resolves and instantiates a new factory for the given browser name.
    #
    # @example Create a new firefox factory
    #   factory = BrowserFactory.new(:firefox)
    #   # => #<MediawikiSelenium::BrowserFactory::Firefox>
    #   factory.browser_for(env) # => #<Watir::Browser>
    #
    # @param browser_name [Symbol] Browser name.
    #
    # @return [BrowserFactory::Base]
    #
    def self.new(browser_name)
      factory_class = const_get(browser_name.to_s.split('_').map(&:capitalize).join(''))
      factory_class.new(browser_name)
    end
  end
end
