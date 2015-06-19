require 'mediawiki_api'

module MediawikiSelenium
  # Factory class used to provision test user fixtures via the MW API.
  #
  class UserFactory
    # Create a user factory. This should typically be done anew for each test
    # case.
    #
    # @param api [MediawikiApi::Client] API client used to create users.
    #
    def initialize(api)
      @api = api
      @users = {}
    end

    # Return a unique name for the given user ID. Each account will be created
    # via the MW API if it has not already been created.
    #
    # @param id [Symbol, nil] Alternative ID or `nil` for the primary user.
    #
    # @return [Hash]
    #
    def create(id = nil)
      return @users[id] if @users.include?(id)

      user = unique(id, 'User')
      pass = unique(id, 'Pass')

      create_account(user, pass)

      @users[id] = { user: user, password: pass }
    end

    private

    def create_account(user, password)
      @api.create_account(user, password)
    rescue MediawikiApi::ApiError => e
      raise e unless e.code == 'userexists'
    end

    def unique(id, label)
      prefix = label
      prefix += "-#{id.to_s.gsub('_', '-')}" if id

      "#{prefix}-#{Random.rand(36**10).to_s(36)}"
    end
  end
end
