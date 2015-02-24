require 'thor'

module MediawikiSelenium
  # Creates the directory structure and configuration for a brand new
  # MediaWiki related test suite.
  #
  class Initializer < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../../../templates', __FILE__)
    end

    desc 'install', 'Creates tests/browser directory structure and default configuration'
    def install
      directory('tests')
    end
  end
end
