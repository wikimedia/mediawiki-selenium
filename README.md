# Mediawiki::Selenium

Several MediaWiki extensions share code that makes it easy to run Selenium tests. This gem
makes it easy to update the shared code.

## Installation

To run the Selenium tests you will have to install Ruby. Look at the `Gemfile` file for the exact required version. You also have to install the latest versions of RubyGems and Firefox (the default browser in which the tests run). The easiest way to install Ruby on Linux/Unix/Mac is [RVM](https://rvm.io/) and on Windows [RubyInstaller](http://rubyinstaller.org/).
ALERT: On Windows you must use Ruby 1.9.3 for now because cucumber/gherkin library currently doesn't work with Ruby 2.x.x.

    cd /tests/browser
    gem update --system
    gem install bundler
    bundle install

If you're not using RVM to manage your Ruby versions, you will need to run the commands as root (using `sudo`).

Environment variables MEDIAWIKI_USER and MEDIAWIKI_PASSWORD are required for tests tagged `@login`. For local testing, create a test user on your local wiki and export the user and password as the values for those variables.
For example:

    export MEDIAWIKI_USER=<username here> # Linux/Unix/Mac
    set MEDIAWIKI_USER=<username here> # Windows

    export MEDIAWIKI_PASSWORD=<password here> # Linux/Unix/Mac
    set MEDIAWIKI_PASSWORD=<password here> # Windows

## Usage

Run the tests with `bundle exec cucumber`, this should start Firefox.

By default the tests run at en.wikipedia.beta.wmflabs.org. If you want to run the tests elsewhere, set the `MEDIAWIKI_URL` environment variable. For example:

    export MEDIAWIKI_URL=http://commons.wikimedia.beta.wmflabs.org/wiki/ # Linux/Unix/Mac
    set MEDIAWIKI_URL=http://commons.wikimedia.beta.wmflabs.org/wiki/ # Windows

To run a single test file enter `bundle exec cucumber features/FEATURE_NAME.feature`.

To run a single test scenario, put a colon and the line number (NN) on which the scenario begins after the file name: `bundle exec cucumber features/FEATURE_NAME.feature:NN`.

You can use a different browser with the `BROWSER` env variable, the fastest is probably PhantomJS, a headless browser:

    export BROWSER=phantomjs # Linux/Unix/Mac
    set BROWSER=phantomjs # Windows

By default, the browser will close itself at the end of every scenario. If you want the browser to stay open, set the environment variable `KEEP_BROWSER_OPEN` to `true`:

    export KEEP_BROWSER_OPEN=true # Linux/Unix/Mac
    set KEEP_BROWSER_OPEN=true # Windows

## Screenshots

You can get screenshots on failures (since 0.2.1) by setting the environment variable SCREENSHOT_FAILURES to "true", screenshots will be written under the `screenshots` directory relatively to working directory. The SCREENSHOT_FAILURES_PATH environment variable (since 0.2.2) let you override the destination path for screenshots. Example:

  SCREENSHOT_FAILURES=true SCREENSHOT_FAILURES_PATH="/tmp/screenshots" bundle exec cucumber

## Update your Gemfile

In your repository, the Gemfile specify dependencies and Gemfile.lock defines the whole dependency tree. To update it simply run:

    bundle update

It will fetch all dependencies and updates the Gemfile.lock file, you can then commit back both files.

## Links

mediawiki_selenium gem: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium), [GitHub](https://github.com/wikimedia/mediawiki-selenium), [RubyGems](https://rubygems.org/gems/mediawiki_selenium), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-selenium)

If not stated differently, Selenium tests are in `/tests/browser` folder.

Repositories that use the gem:

1. CirrusSearch: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/CirrusSearch), [GitHub](https://github.com/wikimedia/mediawiki-extensions-CirrusSearch), [Jenkins](https://wmf.ci.cloudbees.com/view/cs/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-CirrusSearch)
2. ContentTranslation: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/ContentTranslation), [GitHub](https://github.com/wikimedia/mediawiki-extensions-ContentTranslation), [Jenkins](https://wmf.ci.cloudbees.com/view/cx/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-ContentTranslation)
3. Flow: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Flow), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Flow), [Jenkins](https://wmf.ci.cloudbees.com/view/flow/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Flow)
4. MobileFrontend: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/MobileFrontend), [GitHub](https://github.com/wikimedia/mediawiki-extensions-MobileFrontend), [Jenkins](https://wmf.ci.cloudbees.com/view/mf/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-MobileFrontend)
5. MultimediaViewer: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/MultimediaViewer), [GitHub](https://github.com/wikimedia/mediawiki-extensions-MultimediaViewer), [Jenkins](https://wmf.ci.cloudbees.com/view/mv/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-MultimediaViewer)
6. Translate: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Translate), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Translate), [Jenkins](https://wmf.ci.cloudbees.com/view/tr/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Translate)
7. TwnMainPage: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/TwnMainPage), [GitHub](https://github.com/wikimedia/mediawiki-extensions-TwnMainPage), [Jenkins](https://wmf.ci.cloudbees.com/view/tmp/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-TwnMainPage)
8. UniversalLanguageSelector: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/UniversalLanguageSelector), [GitHub](https://github.com/wikimedia/mediawiki-extensions-UniversalLanguageSelector), [Jenkins](https://wmf.ci.cloudbees.com/view/uls/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-UniversalLanguageSelector)
9. UploadWizard: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/UploadWizard), [GitHub](https://github.com/wikimedia/mediawiki-extensions-UploadWizard), [Jenkins](https://wmf.ci.cloudbees.com/view/uw/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-UploadWizard)
10. VisualEditor: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/VisualEditor), [GitHub](https://github.com/wikimedia/mediawiki-extensions-VisualEditor), [Jenkins](https://wmf.ci.cloudbees.com/view/ve/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-VisualEditor), `/modules/ve-mw/test/browser` folder
11. Wikibase: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Wikibase), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Wikibase), [Jenkins](http://wikidata-jenkins.wmflabs.org/ci/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Wikibase)
12. WikiLove: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/WikiLove), [GitHub](https://github.com/wikimedia/mediawiki-extensions-WikiLove), [Jenkins](https://wmf.ci.cloudbees.com/view/wl/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-WikiLove)
13. ZeroRatedMobileAccess: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/ZeroRatedMobileAccess), [GitHub](https://github.com/wikimedia/mediawiki-extensions-ZeroRatedMobileAccess), [Jenkins](https://wmf.ci.cloudbees.com/view/zero/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-ZeroRatedMobileAccess)
14. browsertests: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/qa/browsertests), [GitHub](https://github.com/wikimedia/qa-browsertests), [Jenkins](https://wmf.ci.cloudbees.com/view/bt/), [Code Climate](https://codeclimate.com/github/wikimedia/qa-browsertests)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

https://www.mediawiki.org/wiki/QA/Browser_testing#How_to_contribute
