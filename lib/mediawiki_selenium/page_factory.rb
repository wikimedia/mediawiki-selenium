module MediawikiSelenium
  # Handles on-demand browser instantiation and assignment of the `@browser`
  # instance variable before delegating to `PageObject::PageFactory` methods.
  #
  module PageFactory
    include PageObject::PageFactory

    # Instantiates a new browser, unless `@browser` is set already, and
    # delegates to `PageObject::PageFactory#on_page`.
    #
    # @see http://www.rubydoc.info/github/cheezy/page-object
    #
    def on_page(*arguments)
      @browser = browser unless defined?(@browser)
      super
    end
  end
end
