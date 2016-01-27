module MediawikiSelenium
  # Embeds the browser session upon creation into the active Cucumber logger.
  #
  module EmbedBrowserSession
    # Embeds the browser session into the active Cucumber logger(s) as soon as
    # {Environment} is done creating it. Note that the
    # 'application/vnd.webdriver-session-id' MIME used for the embedding is
    # made up for this purpose.
    #
    # @see Environment#browser
    #
    def browser
      super.tap do |b|
        if b.driver.respond_to?(:session_id)
          embed(b.driver.session_id, 'application/vnd.webdriver-session-id')
        end
      end
    end
  end
end
