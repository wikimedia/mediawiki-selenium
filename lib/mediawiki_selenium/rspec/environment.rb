module MediawikiSelenium
  module RSpec
    module Environment
      # Sets up and returns a new default environment.
      #
      # @return [Environment]
      #
      def mw
        @_mw ||= MediawikiSelenium::Environment.load_default.extend(
          MediawikiSelenium::ApiHelper,
          MediawikiSelenium::PageFactory,
          MediawikiSelenium::ScreenshotHelper,
          MediawikiSelenium::UserFactoryHelper
        )
      end

      private

      # Allow for indirect calls to the {Environment} object.
      #
      # @see mw
      #
      def method_missing(name, *args, &block)
        mw.respond_to?(name) ? mw.__send__(name, *args, &block) : super
      end

      # Allow for indirect calls to the {Environment} object.
      #
      # @see mw
      #
      def respond_to_missing?(name, include_all = false)
        mw.respond_to?(name) || super
      end
    end
  end
end
