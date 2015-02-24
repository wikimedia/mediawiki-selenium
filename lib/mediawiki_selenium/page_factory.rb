require 'page-object'

module MediawikiSelenium
  # Handles on-demand browser instantiation and assignment of the `@browser`
  # instance variable before delegating to `PageObject::PageFactory` methods.
  #
  module PageFactory
    include ::PageObject::PageFactory

    # Instantiates a new browser before delegating to
    # `PageObject::PageFactory#on_page`. All page URLs are also qualified
    # using {Environment#wiki_url}.
    #
    # @see http://www.rubydoc.info/github/cheezy/page-object
    #
    def on_page(page_class, params = { using_params: {} }, visit = false)
      @browser = browser if visit

      super(page_class, params, false).tap do |page|
        if page.respond_to?(:goto)
          wiki_url = method(:wiki_url)

          page.define_singleton_method(:page_url_value) do
            wiki_url.call(super())
          end

          page.goto if visit
        end

        yield page if block_given?
      end
    end

    # @see #on_page
    alias on on_page

  end
end
