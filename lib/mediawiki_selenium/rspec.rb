require 'rspec/core'
require 'mediawiki_selenium'
require 'mediawiki_selenium/rspec/features'

module MediawikiSelenium
  module RSpec
    # Returns a name for the given example metadata, derived from its example
    # groups and description.
    #
    # @param metadata [RSpec::Core::Metadata, Hash] Base or nested metadata.
    #
    # @return [String]
    #
    def self.example_name(metadata)
      name = metadata[:example_group] ? "#{example_name(metadata[:example_group])} " : ''
      name += metadata[:description_args].first.to_s if metadata[:description_args].any?
      name
    end

    # Returns a status for the given RSpec example result.
    #
    # @param result [Object] Result of `example.run`.
    #
    # @return [:passed, :failed, :skipped]
    #
    def self.example_status(result)
      case result
      when Exception
        :failed
      when String
        :skipped
      else
        :passed
      end
    end

    autoload :Environment, 'mediawiki_selenium/rspec/environment'
  end
end

RSpec.configure do |config|
  config.include MediawikiSelenium::RSpec::Environment

  config.around(:each) do |example|
    name = MediawikiSelenium::RSpec.example_name(example.metadata)

    mw.setup(name: name)
    result = example.run
    mw.teardown(name: name, status: MediawikiSelenium::RSpec.example_status(result))
  end
end
