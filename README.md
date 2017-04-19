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
Replace `x.x.x` with version number from `lib/mediawiki_selenium/version.rb`.

    gem 'mediawiki_selenium', '~> x.x.x'

Install the gem and its dependencies by running `bundle install`. (If
[Bundler](http://bundler.io/) is not yet installed, install it with
`gem install bundler`, or `sudo gem install bundler` if you're using a
system wide Ruby.)

## Upgrading

Please read {file:UPGRADE.md} for documentation on how to upgrade from one
major release to another.

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
definitions, see the documentation for {MediawikiSelenium::Environment}.

## Writing Tests

The ability to write effective and cruft-free tests will come with practice
and greater familiarity with the underlying libraries. On mediawiki.org,
you'll find some helpful [high-level documentation](http://www.mediawiki.org/wiki/Quality_Assurance/Browser_testing/Writing_tests)
to get you started.

To see exactly which methods are available from within step definitions, see
the documentation for {MediawikiSelenium::Environment},
{MediawikiSelenium::ApiHelper}, and {MediawikiSelenium::PageFactory}.

## Running Tests

Execute your tests by running `bundle exec cucumber` from within the
`tests/browser` directory.

By default, the entire suite is run which may take some time. If you wish to
execute scenarios for just a single feature, you can provide the feature file
as an argument.

    bundle exec cucumber feature/some.feature

To run a single scenario, give the line number as well.

    bundle exec cucumber feature/some.feature:11

The set of default configuration to use (see "Getting started") can be
specified by the `MEDIAWIKI_ENVIRONMENT` environment variable, defined
somewhere in your shell profile. If no value is set, an entry called `default`
is loaded.

For example, if your `environments.yml` file looked something like this.

    mw-vagrant-host: &default
      mediawiki_url: http://127.0.0.1:8080/wiki/
      # ...

    mw-vagrant-guest:
      mediawiki_url: http://127.0.0.1/wiki/
      # ...

    beta:
      mediawiki_url: http://en.wikipedia.beta.wmflabs.org/wiki/
      # ...

    default: *default

Defining `MEDIAWIKI_ENVIRONMENT=beta` in your shell would tell MW-Selenium to
use the configuration for `beta` above. Leaving it unset would use the entry
called `default` which in this case points to `mw-vagrant-host`.

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

### User Factory

Setting `user_factory` to `true` for an environment in your `environments.yml`
will enable the {MediawikiSelenium::UserFactoryHelper} module. The module
automatically creates accounts referenced in tests (calls to the `user`,
`password`, or `as_user` methods) using the MW API, and randomizes the actual
user names.

These randomized fixtures can greatly improve the atomicity/isolation of your
scenarios, ensuring control over the initial user state (e.g. an edit count
of 0) or allowing scenarios to run in parallel on the same MW installation.

Note that using this feature will result in a large number of accounts being
created for each run. You'll typically want to enable this feature only for
environments like CI (`integration`) or perhaps your local MW-Vagrant.

    integration:
      user_factory: true
      # ...

    mw-vagrant-host:
      user_factory: true
      # ...

### Screenshots

You can get screenshots on failures by setting the environment
variable `SCREENSHOT_FAILURES` to `true`. Screenshots will be written under the
`screenshots` directory relatively to working directory. The
`SCREENSHOT_FAILURES_PATH` environment variable lets you override
the destination path for screenshots. Example:

    SCREENSHOT_FAILURES=true SCREENSHOT_FAILURES_PATH="/tmp/screenshots" bundle exec cucumber

## [Sauce Labs](https://www.mediawiki.org/wiki/Selenium/Ruby/Target_beta_cluster_using_Sauce_Labs)

Sauce Labs gives you access to a variety of browsers and platforms for testing.

### CI Rake task

To utilize the CI rake task, add the following to your `Rakefile`:

    require 'mediawiki_selenium/rake_task'
    MediawikiSelenium::RakeTask.new

It defaults to look for `environments.yml` and `features` under `tests/browser`.
You can specify the directory:

    require 'mediawiki_selenium/rake_task'
    MediawikiSelenium::RakeTask.new(test_dir: modules/ve-mw/tests/browser)

By default, it will run something like this:

    bundle exec cucumber (...) --tags ~@skip --tags @en.wikipedia.beta.wmflabs.org --tags @firefox

To exclude Cucumber site tag (example: `--tags @en.wikipedia.beta.wmflabs.org`):

    require 'mediawiki_selenium/rake_task'
    MediawikiSelenium::RakeTask.new(site_tag: false)

The above will run:

    bundle exec cucumber (...) --tags ~@skip -tags @firefox

CI specific options are passed to cucumber when the rake task detects the
environment variable WORKSPACE is set. It will emit JUnit results under
`$WORKSPACE/log/junit`. To reproduce that behavior one can:

    export WORKSPACE=/tmp/myplace
    mkdir -p $WORKSPACE/log/junit
    bundle exec rake spec

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

## Releasing the gem

### Step 1

When you're ready to cut a new release, increase the major/minor/patch version (the gem uses [semantic versioning](http://semver.org/)) and add release notes. Release notes should include:

- What has changed
- New features
- Bug fixes
- Possible incompatibilities

Update gem version in `lib/mediawiki_selenium/version.rb`. Add release notes to `RELEASES.md`.

### Step 2

Push the commit to Gerrit. Wait for review and merge.

### Step 3

When the commit is merged into master branch, fetch it and verify the commit is HEAD, for example:

    $ git fetch
    $ git log --oneline --decorate
    123abcd (HEAD, origin/master, origin/HEAD, master, T108873) Release minor version 1.5.1
    ...

### Step 4

This assumes you have working Ruby, RubyGems, RubyGems.org account and are an owner of the gem at the site.

Release the gem:

    $ bundle exec rake release
    mediawiki_selenium x.x.x built to pkg/mediawiki_selenium-x.x.x.gem.
    Tagged vx.x.x.
    Pushed git commits and tags.
    Pushed mediawiki_selenium x.x.x to rubygems.org.

### Step 7

Announce the new release at [QA](https://lists.wikimedia.org/mailman/listinfo/qa) mailing list.

## Release notes

See {file:RELEASES.md}.

## [License](../LICENSE)

© Copyright 2013-2017, Wikimedia Foundation & Contributors. Released under the terms of the GNU General Public License, version 2 or later.

