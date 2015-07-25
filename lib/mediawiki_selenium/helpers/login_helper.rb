require 'uri'

module MediawikiSelenium
  # Expepiates logging in to wikis by authenticating with the MW API and
  # transfering the returned cookie to the current browser.
  #
  module LoginHelper
    # Authenticate with the current wiki's API and save the resulting cookie
    # in the current browser.
    #
    # @param cookies [Hash] Extra cookies to set.
    #
    def log_in(cookies = {})
      visit_wiki do |url|
        uri = URI.parse(url)

        options = {}
        options[:domain] = uri.host unless ['localhost', '127.0.0.1'].include?(uri.host)

        api.cookies.each do |cookie|
          browser.cookies.add cookie.name, cookie.value, options.merge({
            secure: cookie.secure,
            path: cookie.path,
            expires: cookie.expires
          })
        end

        cookies.each do |name, value|
          browser.cookies.add name.to_s, value, options
        end

        browser.refresh
      end
    end
  end
end
