module MediawikiSelenium
  autoload :VERSION, 'mediawiki_selenium/version'
  autoload :ApiHelper, 'mediawiki_selenium/support/modules/api_helper'
  autoload :BrowserFactory, 'mediawiki_selenium/browser_factory'
  autoload :ConfigurationError, 'mediawiki_selenium/configuration_error'
  autoload :Environment, 'mediawiki_selenium/environment'
  autoload :Initializer, 'mediawiki_selenium/initializer'
  autoload :PageFactory, 'mediawiki_selenium/page_factory'
  autoload :Raita, 'mediawiki_selenium/raita'
  autoload :RemoteBrowserFactory, 'mediawiki_selenium/remote_browser_factory'
end
