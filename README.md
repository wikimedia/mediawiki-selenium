# Mediawiki::Selenium

Several MediaWiki extensions share code that makes it easy to run Selenium tests. This gem
makes it easy to update the shared code.

## Installation

Add this line to your application's Gemfile:

    gem 'mediawiki-selenium'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mediawiki-selenium

## Usage

Add the gem to Gemfile.

Create `tests/browser/features/support/env.rb` file with this content: `require 'mediawiki/selenium'`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
