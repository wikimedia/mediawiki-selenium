require "mediawiki_api"

module MediawikiSelenium
  # Provides more direct access to the API client from hooks and step
  # definitions.
  #
  module ApiHelper
    # An authenticated MediaWiki API client.
    #
    # @return [MediawikiApi::Client]
    #
    def api
      @api_cache ||= {}

      url = lookup(:mediawiki_api_url, default: api_url_from(lookup(:mediawiki_url)))

      @api_cache[url] ||= MediawikiApi::Client.new(url).tap do |client|
        client.log_in(user, password)
      end
    end

  end
end
