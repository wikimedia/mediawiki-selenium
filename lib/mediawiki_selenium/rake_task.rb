require 'cucumber/rake/task'
require 'mediawiki_selenium'
require 'uri'

module MediawikiSelenium
  class RakeTask < Cucumber::Rake::Task
    def initialize(name = :selenium, test_dir: Environment.default_test_directory)
      target = File.expand_path(test_dir, Rake.original_dir)
      env = Environment.load_default(target)

      workspace = env.lookup(:workspace, default: nil)
      site = URI.parse(env.lookup(:mediawiki_url)).host
      browser = env.browser_name

      options = Shellwords.escape(test_dir)

      if workspace
        options +=
          ' --backtrace --verbose --color --format pretty'\
          " --format Cucumber::Formatter::Sauce --out '#{workspace}/log/junit'"\
          " --tags @#{site}"
      end

      super(name) do |t|
        t.cucumber_opts = "#{options} --tags @#{browser}"
      end
    end
  end
end
