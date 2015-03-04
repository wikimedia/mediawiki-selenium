# MediaWiki-Selenium

MediaWiki-Selenium is a Ruby framework for the implementation and execution of
acceptance tests against [MediaWiki](https://www.mediawiki.org/wiki/MediaWiki)
installations. It is comprised of a number of core dependencies and native
APIs that help you describe the expected behavior of your MediaWiki-related
features, and drive cross-browser simulations to ensure the correctness of
your implementation.

## Core Dependencies

* [Cucumber](https://github.com/cucumber/cucumber) provides the natural
  [Gherkin](https://github.com/cucumber/cucumber/wiki/Gherkin) language used
  to describe application features, a basic API for binding that natural
  language to step definitions written in Ruby, and a test runner for
  executing the suite.

* [PageObject](https://github.com/cheezy/page-object) helps you to implement
  [PageObject patterns](https://code.google.com/p/selenium/wiki/PageObjects)
  within your test suite that better encapsulate the expected structure and
  mechanics of your application's UI.

* [Watir](https://github.com/watir/watir/) and
  [Selenium](http://docs.seleniumhq.org/) for driving browser sessions.

* [RSpec](https://github.com/rspec/rspec-expectations) for asserting
  expectations of scenario outcomes.

## Installation

Ruby 1.9 or above is required, 2.1 is recommended. The easiest way to install
it is with [RVM](https://rvm.io/) or [rbenv](http://rbenv.org/) on
Linux/Unix/OS X, and with [RubyInstaller](http://rubyinstaller.org/) on
Windows.

Create a `Gemfile` in the root of your MediaWiki-related project that
specifies the version of `mediawiki_selenium` you wish to use (typically the
latest version).

    gem 'mediawiki_selenium', '~> 1.0.0'

Install the gem and its dependencies by running `bundle install`. (If
[Bundler](http://bundler.io/) is not yet installed, install it with
`gem install bundler`, or `sudo gem install bundler` if you're using a
system wide Ruby.)

## Upgrading

Please read the included `UPGRADE.md` for documentation on how to upgrade from
one major release to another.

## Getting Started

Once the gem is installed, run `mediawiki-selenium-init` in your project's
root directory to create a boilerplate configuration under `tests/browser`.

    $ bundle exec mediawiki-selenium-init
        create  tests/browser
        create  tests/browser/environments.yml
        create  tests/browser/features/support/env.rb

Default configuration for various resources (wiki URLs, users, etc.) is
typically loaded from an `environments.yml` YAML file in the current working
directory. It should contain defaults for each environment in which the tests
are expected to run, indexed by environment name. Double check that the
generated file is suitable for how you expect your tests to be run, for
example against [Mediawiki-Vagrant](http://www.mediawiki.org/wiki/MediaWiki-Vagrant)
for local development, or against at least the [Beta Cluster](http://www.mediawiki.org/wiki/Beta_cluster)
for continuous integration.

For details on how environment configuration is loaded and used by step
definitions, see the documentation for `MediawikiSelenium::Environment`.

## Writing Tests

The ability to write effective and cruft-free tests will come with practice
and greater familiarity with the underlying libraries. On mediawiki.org,
you'll find some helpful [high-level documentation](http://www.mediawiki.org/wiki/Quality_Assurance/Browser_testing/Writing_tests)
to get you started.

To see exactly which methods are available from within step definitions, see
the documentation for `MediawikiSelenium::Environment`,
`MediawikiSelenium::ApiHelper`, and `MediawikiSelenium::PageFactory`.

## Running Tests

Execute your tests by running `bundle exec cucumber` from within the
`tests/browser` directory.

By default, the entire suite is run which may take some time. If you wish to
execute scenarios for just a single feature, you can provide the feature file
as an argument.

    bundle exec cucumber feature/some.feature

To run a single scenario, give the line number as well.

    bundle exec cucumber feature/some.feature:11

The set of default configuration to use (see "Getting started") is specified
by the `MEDIAWIKI_ENVIRONMENT` environment variable, which should be defined
somewhere in your shell profile. For example, if you're using
[Mediawiki-Vagrant](http://www.mediawiki.org/wiki/MediaWiki-Vagrant) for your
development and executing tests on the host OS, the environment name would be
`mw-vagrant-host`.

    export MEDIAWIKI_ENVIRONMENT=mw-vagrant-host # Linux/Unix/Mac
    set MEDIAWIKI_URL=mw-vagrant-host # Windows Command Prompt
    $env:MEDIAWIKI_URL="mw-vagrant-host" # Windows PowerShell

Firefox is the default browser, but you can specify a different one by setting
`BROWSER`.

    export BROWSER=phantomjs # Linux/Unix/Mac
    set BROWSER=phantomjs # Windows Command Prompt
    $env:BROWSER="internet_explorer" # Windows PowerShell

By default, the browser will close itself at the end of every scenario. If you
want the browser to stay open, set `KEEP_BROWSER_OPEN` to `true`.

    export KEEP_BROWSER_OPEN=true # Linux/Unix/Mac
    set KEEP_BROWSER_OPEN=true # Windows Command Prompt
    $env:KEEP_BROWSER_OPEN="true" # Windows PowerShell

### Headless Mode

Headless operation can be useful when running tests in an environment where
there's no GUI available, environments such as a continuous integration
server, or a remote SSH session.

There are two basic ways to run in headless mode. The first is achieved by
simply using an inherently headless browser such as PhantomJS.

    BROWSER=phantomjs bundle exec cucumber ...

The second method is to specify a `HEADLESS` environment variable in
combination with a non-headless browser. With this invocation
MediaWiki-Selenium will start up a virtual display to which the browser can
render. (Note that the underlying implementation relies on
[Xvfb](https://en.wikipedia.org/wiki/Xvfb) and so is only supported on Linux.)

    HEADLESS=true BROWSER=firefox bundle exec cucumber ...

Some additional options are available to further customize the headless
behavior.

    export HEADLESS=true

    # Use a different display port (the default is 99)
    HEADLESS_DISPLAY=100 bundle exec cucumber ...

    # Don't reuse an already running xvfb (the default is to reuse)
    HEADLESS_REUSE=false bundle exec cucumber ...

    # Keep xvfb running after execution (the default is to kill it)
    HEADLESS_DESTROY_AT_EXIT=false bundle exec cucumber ...

### Screenshots

You can get screenshots on failures by setting the environment
variable `SCREENSHOT_FAILURES` to `true`. Screenshots will be written under the
`screenshots` directory relatively to working directory. The
`SCREENSHOT_FAILURES_PATH` environment variable lets you override
the destination path for screenshots. Example:

    SCREENSHOT_FAILURES=true SCREENSHOT_FAILURES_PATH="/tmp/screenshots" bundle exec cucumber

## Updating Your Gemfile

In your repository, the `Gemfile` specifies dependencies and `Gemfile.lock` defines
the whole dependency tree. To update it simply run:

    bundle update

It will fetch all dependencies and update the `Gemfile.lock` file, you can then
commit back both files.

## Links

For a list of MediaWiki repositories that use this gem, see the [Repositories with Ruby code](https://www.mediawiki.org/wiki/Repositories_with_Ruby_code) page on mediawiki.org.

## Contributing

See https://www.mediawiki.org/wiki/Gerrit

## Release notes

### 1.0.0 2015-01-16
* Substantial refactoring and backwards incompatible changes
* Implemented an "environment abstraction layer" with the aim to:
  * Improve test determinism by sourcing environment-specific default
    configurations and enforcing an immutable runtime configuration
  * Simplify test patterns by providing DSL constructs around commonly tested
    MediaWiki resources
  * Manage multiple isolated browser sessions within a single test scenario
  * Serve more advanced use cases by supporting ad hoc browser customization
* Cleaned up the global object space by moving methods into the new
  `Environment` and `BrowserFactory` classes
* Further decoupled core framework from Cucumber, allowing for the possibility
  of its use under other Ruby test frameworks like RSpec
* Established test suite with coverage for all newly implemented EAL modules
  and classes
* Improved high level and inline documentation with examples and links to
  upstream resources

### 0.4.1 2014-11-11
* Additional headless environment variables: HEADLESS_DISPLAY, HEADLESS_REUSE, HEADLESS_DESTROY_AT_EXIT.

### 0.4.0 2014-09-23

* Stricter pending behavior for falsely passing steps
* Fixed interoperability of custom browser settings and Sauce sessions

### 0.3.2 2014-08-26

* Bumped runtime dependency for mediawiki_api

### 0.3.1 2014-08-12

* Fixed API request for wiki extensions in dependency check
* Updated readme to include documentation on MEDIAWIKI_API_URL

### 0.3.0 2014-08-08

* Support for MediaWiki extension dependencies via `@extension-<name>` tags
* World `api` helper method for direct access to a pre-authenticated API client
* Gem dependency fixes
* Updated readme

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
