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

mediawiki-selenium gem: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium), [GitHub](https://github.com/wikimedia/mediawiki-selenium), [RubyGems](https://rubygems.org/gems/mediawiki-selenium), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-selenium)

Repositories that use the gem:

- CirrusSearch: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/CirrusSearch), [GitHub](https://github.com/wikimedia/mediawiki-extensions-CirrusSearch), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-CirrusSearch), `/tests/browser` folder
- Flow: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Flow), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Flow), [Jenkins](https://wmf.ci.cloudbees.com/view/r-fl/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Flow), `/tests/browser` folder
- MobileFrontend: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/MobileFrontend), [GitHub](https://github.com/wikimedia/mediawiki-extensions-MobileFrontend), [Jenkins](https://wmf.ci.cloudbees.com/view/r-mf/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-MobileFrontend), `/tests/browser` folder
- Translate: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Translate), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Translate), [Jenkins](https://wmf.ci.cloudbees.com/view/r-tr/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Translate), `/tests/browser` folder
- TwnMainPage: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/TwnMainPage), [GitHub](https://github.com/wikimedia/mediawiki-extensions-TwnMainPage), [Jenkins](https://wmf.ci.cloudbees.com/view/r-tw/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-TwnMainPage), `/tests/browser` folder
- UniversalLanguageSelector: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/UniversalLanguageSelector), [GitHub](https://github.com/wikimedia/mediawiki-extensions-UniversalLanguageSelector), [Jenkins](https://wmf.ci.cloudbees.com/view/r-uls/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-UniversalLanguageSelector), `/tests/browser` folder
- VisualEditor: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/VisualEditor), [GitHub](https://github.com/wikimedia/mediawiki-extensions-VisualEditor), [Jenkins](https://wmf.ci.cloudbees.com/view/r-ve/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-VisualEditor), `/modules/ve-mw/test/browser` folder
- Wikibase: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/extensions/Wikibase), [GitHub](https://github.com/wikimedia/mediawiki-extensions-Wikibase), [Jenkins](https://wikidata-cloudbees.ci.cloudbees.com/), [Code Climate](https://codeclimate.com/github/wikimedia/mediawiki-extensions-Wikibase), `/selenium_cuc` folder
- browsertests: [Gerrit](https://gerrit.wikimedia.org/r/#/admin/projects/qa/browsertests), [GitHub](https://github.com/wikimedia/qa-browsertests), [Jenkins](https://wmf.ci.cloudbees.com/view/r-bt/), [Code Climate](https://codeclimate.com/github/wikimedia/qa-browsertests), `/` folder

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
