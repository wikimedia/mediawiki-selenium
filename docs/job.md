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

    export MEDIAWIKI_USER=${MEDIAWIKI_USER}
    export MEDIAWIKI_PASSWORD_VARIABLE=${MEDIAWIKI_PASSWORD_VARIABLE}

    export BROWSER_LABEL=${BROWSER_LABEL}
    export MEDIAWIKI_URL=http://${MEDIAWIKI_URL}/wiki/

    curl -s -o use-ruby https://repository-cloudbees.forge.cloudbees.com/distributions/ci-addons/ruby/use-ruby
    RUBY_VERSION=2.0.0-p247 \
      source ./use-ruby

    gem install bundler --no-ri --no-rdoc
    if [ -d "${FOLDER}" ]; then cd ${FOLDER}; fi
    bundle install
    bundle exec ${BUNDLE_EXEC}

--

  - Post-build Actions > Add post-build action
    - Publish JUnit test result report > Test report XMLs: reports/junit/*.xml
    - E-mail Notification > Recipients: (recipients)
    - IRC Notification
