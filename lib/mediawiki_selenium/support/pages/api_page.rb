class APIPage
  include PageObject

  def create title, content
    abort "Environment variable MEDIAWIKI_API_URL must be set in order to create a target page for this test" unless ENV["MEDIAWIKI_API_URL"]

    client = MediawikiApi::Client.new ENV["MEDIAWIKI_API_URL"]
    client.log_in ENV["MEDIAWIKI_USER"], ENV["MEDIAWIKI_PASSWORD"]
    client.create_page @random_string, @random_string
  end
end
