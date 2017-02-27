## Release notes

### 1.8.0 2017-02-27
* Remove raita entirely
* Major updates in dependencies:
  * page-object updated to version 2
  * Watir updated to version 6
  * Selenium updated to version 3
* Major changes caused by upgrade to Selenium 3:
  * default browser is Chrome, instead of Firefox
  * geckodriver needs to be installed when driving Firefox
* For more information about upstream changes:
  * Selenium:
    * Blog: https://seleniumhq.wordpress.com/
    * Release notes: https://github.com/SeleniumHQ/selenium/blob/master/rb/CHANGES
  * Watir:
    * Blog: http://watir.github.io/blog/
    * Release notes: https://github.com/watir/watir/blob/master/CHANGES.md
  * page-object release notes: https://github.com/cheezy/page-object/blob/master/ChangeLog

### 1.7.4 2016-12-28

* Update JSON gem to version 2
* Fix NameError: uninitialized constant MediawikiSelenium::RakeTask::Shellwords

### 1.7.3 2016-12-06

* Helper that allows you to query whether JavaScript module has loaded

### 1.7.2 2016-08-03

* Bump mediawiki_api dependency to 0.7 for automatic redirect support.

### 1.7.1 2016-05-26

* Bump mediawiki_api dependency to 0.6. MediaWiki API changed, the new version is needed going
  forward.

### 1.7.0 2016-04-25

* Provide Rake task to serve as a CI entrypoint

### 1.6.5 2016-01-27

* Fixed `NoMethodError` in `EmbedBrowserSession` helper

### 1.6.4 2016-01-27

* Log SauceLabs session URLs via Cucumber logger embeds

### 1.6.3 2015-12-15

* Added support for all SauceLabs provided browsers

### 1.6.2 2015-10-23
* Fixed undefined `last_session_ids=` method bug in `RemoteBrowserFactory`
  which entirely broke SauceLabs use in previous 1.6.x versions

### 1.6.1 2015-09-29
* Fixed bug in `UserFactory#user` and `UserFactory#password` that caused the
  incorrect resolution of alternative users/passwords when in the context of
  `Environment#as_user`

### 1.6.0 2015-09-25
* Factored out all Cucumber specific functionality from the main framework
  classes to make way for alternative test harnesses
  * Generalized setup/teardown hooks
  * Reorganized support files to reflect their Cucumber specificity
  * Refactored remote test annotation
  * Moved screenshot-ing to its own helper
* Experimental support for plain RSpec based tests (see
  [T108273](https://phabricator.wikimedia.org/T108273#1520544) for example
  usage)
* Implemented API based authentication via the `LoginHelper` and ported the
  Cucumber login step to use it

### 1.5.0 2015-07-23
* Video recording of headless browser sessions are now saved to
  `HEADLESS_CAPTURE_PATH` for failed scenarios
* Page objects can now reference the current `Environment` object as `env` in
  their page URL ERb

### 1.4.0 2015-06-26
* New user factory module provides account fixtures for a greater level of
  isolation/atomicity between scenarios
* Updated MediaWiki API client and Cucumber dependencies for various fixes
* Fixed `PageFactory#on` for cases where it's used before browser
  initialization
* Implemented integration tests that run against a MediaWiki instance in CI

### 1.3.0 2015-06-10
* Added `Environment#override` for overriding environment configuration at
  runtime
* Removed deprecated `APIPage` page object and updated upgrade docs

### 1.2.1 2015-06-02
* Fixed issue with inconsistent JSON output in Raita logger when using
  scenario outlines

### 1.2.0 2015-05-28
* Support logging to a [Raita](http://git.wikimedia.org/summary/integration%2Fraita.git)
  Elasticsearch database by setting `RAITA_URL`
* Removed deprecated support for `MEDIAWIKI_PASSWORD_VARIABLE`

### 1.1.0 2015-04-06
* Support for `browser_http_proxy` in Firefox, Chrome, and Phantomjs
* Renamed browser factory `bind` method to `configure`

### 1.0.2 2015-03-26
* Fixed double yield bug in `PageFactory#on`
* Implemented loading of a `default` configuration from `environments.yml`
* Improved readme with configuration examples

### 1.0.1 2015-03-05
* Fixed regex pattern in shared "I am logged in" step

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
