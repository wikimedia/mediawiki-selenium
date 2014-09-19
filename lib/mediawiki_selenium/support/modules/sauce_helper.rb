module MediawikiSelenium
  module SauceHelper
    # The current Sauce session ID.
    #
    # @return [String]
    #
    def sauce_session_id
      @session_id ||= @browser.driver.instance_variable_get(:@bridge).session_id if @browser
    rescue StandardError
      nil
    end
  end
end
