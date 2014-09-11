require "page-object"
require "mediawiki_api"

class APIPage
  include PageObject

  def client
    return @client if defined?(@client)

    unless ENV["MEDIAWIKI_API_URL"]
      raise "Environment variable MEDIAWIKI_API_URL must be set in order to use the API"
    end

    @client = MediawikiApi::Client.new(ENV["MEDIAWIKI_API_URL"])
    @client.log_in ENV["MEDIAWIKI_USER"], ENV["MEDIAWIKI_PASSWORD"]

    @client
  end

  def create(title, content)
    client.create_page title, content
  end

  def protect(title, reason)
    client.protect_page title, reason
  end
end
