module MediawikiSelenium
  # Browser factory.
  #
  module BrowserFactory
    autoload :Base, "mediawiki_selenium/browser_factory/base"
    autoload :Firefox, "mediawiki_selenium/browser_factory/firefox"
    autoload :Chrome, "mediawiki_selenium/browser_factory/chrome"
    autoload :Phantomjs, "mediawiki_selenium/browser_factory/phantomjs"

    # Resolves a new factory for the given browser name.
    #
    # @param name [Symbol] Browser name.
    #
    # @return [BrowserFactory::Base]
    #
    def self.new(name)
      factory_class = const_get(name.to_s.split("_").map(&:capitalize).join(""))
      factory_class.new(name)
    end
  end
end
