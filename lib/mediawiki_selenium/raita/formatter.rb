require 'gherkin/formatter/json_formatter'

module MediawikiSelenium
  module Raita
    class Formatter < Gherkin::Formatter::JSONFormatter
      attr_reader :feature_hashes

      def initialize
        super(NullIO.new)
      end
    end
  end
end
