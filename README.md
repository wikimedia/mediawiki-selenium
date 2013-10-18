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

## Links

mediawiki-selenium gem at various sites:

- https://rubygems.org/gems/mediawiki-selenium
- https://github.com/wikimedia/mediawiki-selenium
- https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium

Repositories that use the gem:

- CirrusSearch: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/CirrusSearch), [GitHub](https://github.com/wikimedia/mediawiki-extensions-CirrusSearch), `/tests/browser` folder
- Flow: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Flow), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Flow), `/tests/browser` folder
- MobileFrontend: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/MobileFrontend), [GitHub](https://github.com/wikimedia/mediawiki-extensions-MobileFrontend), `/tests/acceptance` folder
- Translate: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Translate), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Translate), `/tests/browser` folder
- TwnMainPage: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/TwnMainPage), [GitHub](https://github.com/wikimedia/mediawiki-extensions-TwnMainPage), `/tests/browser` folder
- UniversalLanguageSelector: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/UniversalLanguageSelector), [GitHub](https://github.com/wikimedia/mediawiki-extensions-UniversalLanguageSelector), `/tests/browser` folder
- VisualEditor: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/VisualEditor), [GitHub](https://github.com/wikimedia/mediawiki-extensions-VisualEditor), `/modules/ve-mw/test/browser` folder
- Wikibase: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Wikibase), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Wikibase), `/selenium_cuc` folder
- browsertests: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/qa/browsertests), [GitHub](https://github.com/wikimedia/qa-browsertests), `/` folder

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
