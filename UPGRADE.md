# Upgrading to various major and minor releases

You can check your current version by running `bundle list mediawiki_selenium`
in the root directory of your project.

## From 1.x releases to 1.6.x

### Update your `Gemfile`

First, update the `Gemfile` in your project's root directory to specify the
new version.

    gem 'mediawiki_selenium', '~> 1.6.3'

### Update `require` paths in `env.rb`

The 1.6 release of MW-Selenium decoupled much of the Cucumber specific
implementation to make room for alternative test harnesses such as RSpec. Some
support files were moved around to make this separation clearer.

Assuming you're using Cucumber, which is still the default harness, update the
first set of `require` statements in `tests/browser/features/support/env.rb`
to the following.

    require 'mediawiki_selenium/cucumber'
    require 'mediawiki_selenium/pages'
    require 'mediawiki_selenium/step_definitions'

Note that you can always omit the page object and step definition statements
if they don't apply to your test cases. The only must have is the first
`require`.

## From pre-1.0 releases to 1.x

### Update your `Gemfile`

First, update the `Gemfile` in your project's root directory to specify the
new version.

    gem 'mediawiki_selenium', '~> 1.6.3'

### Upgrade gems and dependencies

Now run `bundle install` to update your project's gem dependencies and
`Gemfile.lock`.

### Run the initialization script

Version 1.0 now includes an initialization script that can help with the setup
of new and existing test suites. Run the script in your project's root
directory via Bundler.

    bundle exec mediawiki-selenium-init

Two important files will be created if they don't already exist. The first is
an `environments.yml` configuration file that describes the environments in
which you intend your test suite to run. For details on how it should be
configured, consult the "Getting Started" section of the `README`.

The second file, `tests/browser/features/support/env.rb`, is for bootstrapping
the Cucumber environment. Since you're working with an existing test suite,
you may run into a conflict here. Just make sure that your `env.rb` contains
the following before anything else.

    require 'mediawiki_selenium/cucumber'
    require 'mediawiki_selenium/pages'
    require 'mediawiki_selenium/step_definitions'

### Convert page object URLs

Convert all page object URLs so that they're defined relative to the root of
any given wiki and no longer rely on the now deprecated `URL` module. In other
words, change page object classes like the following.

    class MainPage
      include PageObject
      include URL
    
      page_url URL.url('Main_Page')

      # ...
    end

To something like this.

    class MainPage
      include PageObject
    
      page_url 'Main_Page'

      # ...
    end

### Refactor direct use of `ENV`

Change all references to `ENV` to use the appropriate `Environment` method.

For example, change things like:

    Given(/^I am logged in to the primary wiki domain$/) do
      visit(LoginPage).login_with(ENV["MEDIAWIKI_USER"], ENV["MEDIAWIKI_PASSWORD"])
    end

To something like:

    Given(/^I am logged in to the primary wiki domain$/) do
      visit(LoginPage).login_with(user, password)
    end

More esoteric configuration that isn't accessible via a method of
`Environment` can still be read via `Environment#lookup` and `Environment#[]`.

Change something like the following:

    Then(/^the default language should reflect my browser language$/) do
      on(PreferencesPage) do |page|
        expect(page.language_preference).to eq(ENV['BROWSER_LANGUAGE'])
      end
    end

To something like:

    Then(/^the default language should reflect my browser language$/) do
      on(PreferencesPage) do |page|
        expect(page.language_preference).to eq(env[:browser_language])
        # or
        expect(page.language_preference).to eq(lookup(:browser_language))
      end
    end

### Remove direct references to `@browser`

All references to `@browser` should use `Environment#browser` instead, since
the latter will automatically configure and launch the browser the first time
it's needed.

For example:

    When(/^I am viewing Topic page$/) do
      on(FlowPage).wait_until { @browser.url =~ /Topic/ }
    end

Would be changed to:

    When(/^I am viewing Topic page$/) do
      on(FlowPage).wait_until { browser.url =~ /Topic/ }
    end

### Refactor use of deprecated `APIPage`

API requests should be made directly using {MediawikiSelenium::ApiHelper#api}
which returns an instance of [MediawikiApi::Client](https://doc.wikimedia.org/rubygems/mediawiki-ruby-api/).

For example:

    Given(/^the "(.*)" article contains "(.*)"$/) do |title, text|
      on(APIPage).create(title, text)
    end

Would be changed to:

    Given(/^the "(.*)" article contains "(.*)"$/) do |title, text|
      api.create_page(title, text)
    end
