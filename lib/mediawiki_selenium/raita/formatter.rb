require 'gherkin/formatter/json_formatter'

module MediawikiSelenium
  module Raita
    class Formatter < Gherkin::Formatter::JSONFormatter
      attr_reader :feature_hashes

      def initialize
        super(NullIO.new)
      end

      # Allows for simple embeddings without base64 encoding.
      #
      def embedding(mime_type, data)
        return unless mime_type.start_with?('text/')

        embeddings << { 'mime_type' => mime_type, 'data' => data }
      end
    end
  end
end
