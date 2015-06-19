require 'mediawiki_api'

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
      @_api_cache ||= {}

      url = api_url

      @_api_cache[[url, user]] ||= MediawikiApi::Client.new(url).tap do |client|
        client.log_in(user, password)
      end
    end

    # URL to the API endpoint for the current wiki.
    #
    # @return [String]
    #
    def api_url
      lookup(:mediawiki_api_url, default: -> { api_url_from(lookup(:mediawiki_url)) })
    end

    # Ensures the given alternative account exists by attempting to create it
    # via the API. Any errors related to the account already existing are
    # swallowed.
    #
    # @param id [Symbol] ID of alternative user.
    #
    def ensure_account(id)
      api.create_account(user(id), password(id))
    rescue MediawikiApi::ApiError => e
      raise e unless e.code == 'userexists'
    end

    # Extends parent implementation to also override the API URL. If no API
    # URL is explicitly defined for the given alternative, one is constructed
    # relative to the wiki URL.
    #
    # @yield [wiki_url, api_url]
    # @yieldparam wiki_url [String] Alternative wiki URL.
    # @yieldparam api_url [String] Alternative API URL.
    #
    # @see Environment#on_wiki
    #
    def on_wiki(id, &blk)
      super(id) do |wiki_url|
        api_url = lookup(:mediawiki_api_url, id: id, default: -> { api_url_from(wiki_url) })
        return with(mediawiki_url: wiki_url, mediawiki_api_url: api_url, &blk)
      end
    end

    private

    def api_url_from(wiki_url)
      URI.parse(wiki_url).merge('/w/api.php').to_s
    end
  end
end
