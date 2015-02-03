# Upgrading from pre-1.0 releases to 1.0.0 and above

## Update your `Gemfile`

First, update the `Gemfile` in your project's root directory to specify the
new version.

    gem 'mediawiki_selenium', '~> 1.0.0.pre.1'

## Upgrade gems and dependencies

Now run `bundle install` to update your project's gem dependencies and
`Gemfile.lock`.

## Run the initialization script

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

    require 'mediawiki_selenium'
    require 'mediawiki_selenium/support'
    require 'mediawiki_selenium/step_definitions'

## Convert page object URLs

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
