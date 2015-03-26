module MediawikiSelenium
  # Supports logging to a Raita Elasticsearch index. Raita is a dashboard for
  # visualizing and taking action on the results of Cucumber tests.
  #
  module Raita
    # Mapping of environment configuration/variables to Raita build fields.
    #
    ENV_TO_BUILD_MAPPING = {
      build_number:          :number,
      build_url:             :url,
      job_name:              [:project, :name],
      git_commit:            [:project, :commit],
      git_branch:            [:project, :branch],
      git_url:               [:project, :repo],
      mediawiki_environment: [:environment, :name],
      mediawiki_url:         [:environment, :url],
      browser:               [:browser, :name],
      version:               [:browser, :version],
      platform:              [:browser, :platform]
    }

    autoload :Formatter, 'mediawiki_selenium/raita/formatter'
    autoload :Logger, 'mediawiki_selenium/raita/logger'
    autoload :NullIO, 'mediawiki_selenium/raita/null_io'

    # Returns a hash of relevant build information from the given {Environment}.
    #
    # @param env {Environment}
    #
    # @return {Hash} Raita build object.
    #
    def self.build_from(env)
      ENV_TO_BUILD_MAPPING.each.with_object({}) do |(from, to), build|
        value = env.lookup(from, default: nil)

        case to
        when Array
          build[to.first] ||= {}
          build[to.first][to.last] = value
        else
          build[to] = value
        end
      end
    end
  end
end
