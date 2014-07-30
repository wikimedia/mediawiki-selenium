require "mediawiki_api"

module MediawikiSelenium
  # Provides more direct access to the API client from hooks and step
  # definitions.
  #
  module ApiHelper
    # A pre-authenticated API client.
    #
    # @return [MediawikiApi::Client]
    #
    def api
      return @api if defined?(@api)

      @api = MediawikiApi::Client.new(ENV["MEDIAWIKI_API_URL"])
      @api.log_in(*ENV.values_at("MEDIAWIKI_USER", "MEDIAWIKI_PASSWORD")) unless @api.logged_in?
      @api
    end
  end
end
