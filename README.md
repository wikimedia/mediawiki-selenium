# Mediawiki::Selenium

Several MediaWiki extensions share code that makes it easy to run Selenium
tests. This gem makes it easy to update the shared code.

## Installation

To run the Selenium tests you will have to install Ruby. Look at the `Gemfile`
file for the exact required version. You also have to install the latest
versions of RubyGems and Firefox (the default browser in which the tests run).
The easiest way to install Ruby on Linux/Unix/Mac is [RVM](https://rvm.io/) and
on Windows [RubyInstaller](http://rubyinstaller.org/).

    cd /tests/browser
    gem update --system
    gem install bundler
    bundle install

If you're not using RVM to manage your Ruby versions, you will need to run the
commands as root (using `sudo`).

Environment variables `MEDIAWIKI_USER` and `MEDIAWIKI_PASSWORD` are required for
tests tagged `@login`. For local testing, create a test user on your local wiki
and export the user and password as the values for those variables.
For example:

    export MEDIAWIKI_USER=<username here> # Linux/Unix/Mac
    set MEDIAWIKI_USER=<username here> # Windows Command Prompt
    $env:MEDIAWIKI_USER="<username here>" # Windows PowerShell

    export MEDIAWIKI_PASSWORD=<password here> # Linux/Unix/Mac
    set MEDIAWIKI_PASSWORD=<password here> # Windows Command Prompt
    $env:MEDIAWIKI_PASSWORD="<password here>" # Windows PowerShell

## Usage

Run the tests with `bundle exec cucumber`, this should start Firefox.

By default the tests run at en.wikipedia.beta.wmflabs.org. If you want to run
the tests elsewhere, set the `MEDIAWIKI_URL` environment variable. For example:

    export MEDIAWIKI_URL=http://commons.wikimedia.beta.wmflabs.org/wiki/ # Linux/Unix/Mac
    set MEDIAWIKI_URL=http://commons.wikimedia.beta.wmflabs.org/wiki/ # Windows Command Prompt
    $env:MEDIAWIKI_URL="http://commons.wikimedia.beta.wmflabs.org/wiki/" # Windows PowerShell

To run a single test file:

    bundle exec cucumber features/FEATURE_NAME.feature

To run a single test scenario, put a colon and the line number (NN) on which
the scenario begins after the file name:

    bundle exec cucumber features/FEATURE_NAME.feature:NN

You can use a different browser with the `BROWSER` env variable, the fastest is
probably PhantomJS, a headless browser:

    export BROWSER=phantomjs # Linux/Unix/Mac
    set BROWSER=phantomjs # Windows Command Prompt
    $env:BROWSER="internet_explorer" # Windows PowerShell

By default, the browser will close itself at the end of every scenario. If you
want the browser to stay open, set the environment variable `KEEP_BROWSER_OPEN`
to `true`:

    export KEEP_BROWSER_OPEN=true # Linux/Unix/Mac
    set KEEP_BROWSER_OPEN=true # Windows Command Prompt
    $env:KEEP_BROWSER_OPEN="true" # Windows PowerShell

## Screenshots

You can get screenshots on failures by setting the environment
variable `SCREENSHOT_FAILURES` to `true`. Screenshots will be written under the
`screenshots` directory relatively to working directory. The
`SCREENSHOT_FAILURES_PATH` environment variable lets you override
the destination path for screenshots. Example:

    SCREENSHOT_FAILURES=true SCREENSHOT_FAILURES_PATH="/tmp/screenshots" bundle exec cucumber

## Update your Gemfile

In your repository, the `Gemfile` specifies dependencies and `Gemfile.lock` defines
the whole dependency tree. To update it simply run:

    bundle update

It will fetch all dependencies and update the `Gemfile.lock` file, you can then
commit back both files.

## Links

mediawiki_selenium gem: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium), [GitHub](https://github.com/wikimedia/mediawiki-selenium), [RubyGems](https://rubygems.org/gems/mediawiki_selenium), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-selenium)

If not stated differently, Selenium tests are in `/tests/browser` folder and Jenkins jobs are at [integration.wikimedia.org/ci/view/BrowserTests](https://integration.wikimedia.org/ci/view/BrowserTests/).

Repositories that use the gem:

1. ArticleFeedbackv5: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/ArticleFeedbackv5), [GitHub](https://github.com/wikimedia/mediawiki-extensions-ArticleFeedbackv5), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-ArticleFeedbackv5)
1. CirrusSearch: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/CirrusSearch), [GitHub](https://github.com/wikimedia/mediawiki-extensions-CirrusSearch), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-CirrusSearch)
1. ContentTranslation: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/ContentTranslation), [GitHub](https://github.com/wikimedia/mediawiki-extensions-ContentTranslation), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-ContentTranslation)
1. Flow: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Flow), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Flow), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Flow)
1. MediaWiki: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/core), [GitHub](https://github.com/wikimedia/mediawiki-core), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-core)
1. MobileFrontend: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/MobileFrontend), [GitHub](https://github.com/wikimedia/mediawiki-extensions-MobileFrontend), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-MobileFrontend)
1. MultimediaViewer: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/MultimediaViewer), [GitHub](https://github.com/wikimedia/mediawiki-extensions-MultimediaViewer), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-MultimediaViewer)
1. PageTriage: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/PageTriage), [GitHub](https://github.com/wikimedia/mediawiki-extensions-PageTriage), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-PageTriage)
1. Translate: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Translate), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Translate), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Translate)
1. TwnMainPage: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/TwnMainPage), [GitHub](https://github.com/wikimedia/mediawiki-extensions-TwnMainPage), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-TwnMainPage)
1. UniversalLanguageSelector: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/UniversalLanguageSelector), [GitHub](https://github.com/wikimedia/mediawiki-extensions-UniversalLanguageSelector), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-UniversalLanguageSelector)
1. UploadWizard: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/UploadWizard), [GitHub](https://github.com/wikimedia/mediawiki-extensions-UploadWizard), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-UploadWizard)
1. VisualEditor: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/VisualEditor), [GitHub](https://github.com/wikimedia/mediawiki-extensions-VisualEditor), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-VisualEditor), `/modules/ve-mw/tests/browser` folder
1. WikidataBrowserTests: [GitHub](https://github.com/wmde/WikidataBrowserTests), [Code Climate](https://codeclimate.com/github/wmde/WikidataBrowserTests), [Jenkins](http://wdjenkins.wmflabs.org/ci/), `/` folder
1. WikiLove: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/WikiLove), [GitHub](https://github.com/wikimedia/mediawiki-extensions-WikiLove), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-WikiLove)
1. ZeroBanner: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/ZeroBanner), [GitHub](https://github.com/wikimedia/mediawiki-extensions-ZeroBanner), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-ZeroBanner)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Also see https://www.mediawiki.org/wiki/QA/Browser_testing#How_to_contribute

## Release notes

### 0.2.26 2014-07-18

* Added runtime dependency on mediawiki_api
* Added call to #protect from mediawiki_api

### 0.2.25 2014-06-27

* Make the check for complete login independent of language

### 0.2.24 2014-06-12

* No longer using net-http-persistent Ruby gem. Looks like net-http-persistent is causing failures sometimes. Testing if
  things will be more stable without it.

### 0.2.23 2014-06-05

* Take screen shot only if browser is opened
* Upgrade to page-object gem 1.0. New version has better debugging.

### 0.2.22 2014-04-23

* Fixed "File name too long" error message

### 0.2.21 2014-04-22

* Do not output link to Sauce Labs when running a local browser

### 0.2.20 2014-04-15

* Updated readme file with release notes
* `APIPage#create` should use `title` and `content` variables when creating a page

### 0.2.19 2014-04-11

* APIPage can create pages via API

### 0.2.18 2014-04-11

* If environment variable HEADLESS is set to true, run a local browser

### 0.2.17 2014-04-08

* File needed for file upload steps was not required
* Login sometimes takes >5s to complete
* Updated readme file

### 0.2.16 2014-03-21

* MobileFrontend and UploadWizard should share upload steps

### 0.2.15 2014-03-19

* Fixed setting a cookie when starting the browser

### 0.2.14 2014-03-19

* A cookie can optionally be set when starting the browser

### 0.2.13 2014-03-18

* The gem should be able to start local and remote browsers with optional browser setup

### 0.2.12 2014-03-13

* Make "page has no ResourceLoader errors" Cucumber step available

### 0.2.11 2014-03-10

* Add optional argument wait_for_logout_element to login_with method
* Wrapped README.md to 80 chars for readability

### 0.2.10 2014-03-10

* Added "I am at a random page" step to the gem
* Make it possible to check for ResourceLoader errors anywhere

### 0.2.9 2014-03-06

* Fixed login method, instead of waiting for link with text in English, wait for link with href

### 0.2.8 2014-03-06

* Moved BROWSER_TIMEOUT implementation to the gem
* Moved Jenkins doc to jenkins-job-builder-config repo
* Updated Ruby version from 2.1.0 to 2.1.1
* Cloudbees Jenkins jobs are now created using Jenkins Job Builder

### 0.2.7 2014-02-21

* Wait for login process to complete
* Added support for @custom-browser Cucumber tag
* Removed configuration of Sauce Labs browsers from the gem

### 0.2.6 2014-02-18

### 0.2.5 2014-02-17

### 0.2.4 2014-02-17

### 0.2.3 2014-02-13

### 0.2.2 2014-02-10

* `SCREENSHOT_FAILURES_PATH` environment variable lets you override the destination path for screenshots
* Moved resetting preferences to the gem
* Moved Given(/^I am logged in$/) step to the gem
* Renamed remaining instances of mediawiki-selenium to mediawiki_selenium
* Moved LoginPage class and URL module to the gem
* Moved files to support folder

### 0.2.1 2014-02-07

* Get screenshots on failures by setting the environment variable `SCREENSHOT_FAILURES` to `true`
* Add a Gemfile to force a good version of Ruby
* Fixed several "gem build" warnings
* Renamed mediawiki-selenium Ruby gem to mediawiki_selenium
* Added missing contributors

### 0.2.0 2014-02-07

### 0.1.21 2014-02-07

### 0.1.20 2014-01-30

* Added the most recent versions of all runtime dependencies

### 0.1.19 2014-01-30

* Fixed warning message displayed while building the gem
* Display error message if browser is not started for some reason

### 0.1.18 2014-01-30

* Increases verbosity of Cucumber output
* Run browsers headlessly if HEADLESS environment variable is set to true
* Moved Sauce Labs browser configuration to the gem
* Removed debugging code from Jenkins jobs

### 0.1.17 2014-01-28

### 0.1.16 2014-01-17

* Resize PhantomJS to 1280x1024 when the browser opens
* Removed code that is no longer needed
* Send e-mail for every unstable Jenkins job
* All "bundle exec cucumber" should end in "|| echo "Failure in cucumber""
* Use new e-mail template
* Added build schedule option for Jenkins builds
* Deleted unused "branch" option
* Added --backtrace to cucumber
* Updated Ruby
* Replacing single quotes with double quotes
* Fix Accept-Language feature for PhantomJS

### 0.1.15 2013-12-13

### 0.1.14 2013-12-09

* Make it possible to run tests on Cloudbees using PhantomJS
* Merging the readme files of other repositories with this one
* Prefer double-quoted strings in Ruby code
* Added links to Jenkins jobs

### 0.1.13 2013-11-14

* Resize browser at Sauce Labs to maximum supported size

### 0.1.12 2013-11-04

* Introduce new variable that points to the variable that holds the password

### 0.1.11 2013-11-04

* Passwords are in environment variables but not displayed in Jenkins console log
* Set up Code Climate for all repositories that have Ruby code
* Deleted Jenkins jobs that are known to fail
* Updated documentation

### 0.1.10 2013-10-21

* Updated Jenkins documentation
* Moving gems that all repositories need to the gem
* Deleted unused files
* The gem homepage now points to Gerrit repository
* Moved documentation from qa/browsertests repository
* Updated readme file with usage instructions and links to repositories that use the gem
* Add .gitreview

### 0.1.9 2013-10-21

### 0.1.8 2013-10-04

* Use rest_client instead of curl when using Sauce Labs API
* Set build number when running tests at Sauce Labs

### 0.1.7 2013-10-04

* MobileFrontend repository uses @user_agent tag

### 0.1.6 2013-10-04

* Added code needed for CirrusSearch repository

### 0.1.5 2013-10-04

* Move UniversalLanguageSelector hooks back to it's repository

### 0.1.4 2013-10-03

* Remove debugging code committed by mistake

### 0.1.3 2013-10-03

* Moved Cucumber hooks used only for UniversalLanguageSelector to a separate file

### 0.1.2 2013-10-03

* Forgot to require hooks file

### 0.1.1 2013-10-03

* Moved Cucumber hooks to hooks.rb file

### 0.1.0 2013-10-03

* The gem is working, I think it is time to move from 0.0.x

### 0.0.7 2013-10-02

* Moved code from UniversalLanguageSelector repository

### 0.0.6 2013-10-02

* Updated env.rb file to the latest version
* Added license headers to all files that did not have it

### 0.0.5 2013-10-02

* Imported sauce.rb file from browsertests repository

### 0.0.4 2013-10-02

* Include env.rb file from browsertests repository

### 0.0.3 2013-10-02

* Changed license to GPL-2

### 0.0.2 2013-10-02

* Fixed a couple of "gem build" warnings

### 0.0.1 2013-10-02

* Added description and summary to gemspec file
* Auto generated gem by RubyMine
