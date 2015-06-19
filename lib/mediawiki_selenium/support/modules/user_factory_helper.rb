require 'mediawiki_api'

module MediawikiSelenium
  # Provisions user accounts automatically using the MW API upon their first
  # reference.
  #
  # Note you must explicitly enable this functionality by setting
  # `user_factory` to `true` in your `environments.yml` configuration file.
  #
  # @see Environment
  # @see UserFactory
  #
  module UserFactoryHelper
    # @!method user
    # @!method password
    #
    # Create account upon the first reference to its username or password.
    #
    # @see Environment#user
    # @see Environment#password
    #
    [:user, :password].each do |name|
      define_method(name) do |id = nil|
        return super(id) unless lookup(:user_factory, default: false)
        factory.create(id || current_alternative(:"mediawiki_#{name}"))[name]
      end
    end

    private

    def factory
      @_user_factory ||= UserFactory.new(MediawikiApi::Client.new(api_url))
    end
  end
end
