# Job

- Jenkins > New Job
  - Job name: (name)
  - Build a free-style software project
  - OK
- Jenkins > Job > Configure
  - Project name: (name)
  - Source Code Management > Git > Repositories > Repository URL: (repository)
  - Build > Add build step > Execute shell

--

    export BROWSER_LABEL=(label)
    export MEDIAWIKI_URL=(url)

    curl -s -o use-ruby https://repository-cloudbees.forge.cloudbees.com/distributions/ci-addons/ruby/use-ruby
    RUBY_VERSION=2.0.0-p247 \
      source ./use-ruby

    gem install bundler --no-ri --no-rdoc
    bundle install
    bundle exec cucumber

--

  - Post-build Actions > Add post-build action
    - Publish JUnit test result report > Test report XMLs: reports/junit/*.xml
    - E-mail Notification > Recipients: (recipients)
    - IRC Notification
