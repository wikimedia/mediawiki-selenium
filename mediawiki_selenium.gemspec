# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mediawiki_selenium/version'

Gem::Specification.new do |spec|
  spec.name          = 'mediawiki_selenium'
  spec.version       = MediawikiSelenium::VERSION
  spec.authors       = ['Chris McMahon', 'Dan Duvall', 'Jeff Hall', 'Nikolas Everett',
                        'Tobias Gritschacher', 'Željko Filipin']
  spec.email         = ['cmcmahon@wikimedia.org', 'dduvall@wikimedia.org', 'jhall@wikimedia.org',
                        'neverett@wikimedia.org', 'tobias.gritschacher@wikimedia.de',
                        'zeljko.filipin@gmail.com']

  spec.description = (<<-end).split.join(' ')
    Several MediaWiki extensions share code that makes it easy to run Selenium tests. This gem
    makes it easy to update the shared code.
  end

  spec.summary       = 'An easy way to run MediaWiki Selenium tests.'
  spec.homepage      = 'https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium'
  spec.license       = 'GPL-2'

  spec.bindir      = 'bin'
  spec.executables << 'mediawiki-selenium-init'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cucumber', '~> 2.1.0', '>= 2.1.0'
  spec.add_runtime_dependency 'headless', '~> 2.0', '>= 2.1.0'
  spec.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.1'
  spec.add_runtime_dependency 'mediawiki_api', '~> 0.5', '>= 0.5.0'
  spec.add_runtime_dependency 'page-object', '~> 1.0'
  spec.add_runtime_dependency 'rest-client', '~> 1.6', '>= 1.6.7'
  spec.add_runtime_dependency 'rspec-core', '~> 2.14', '>= 2.14.4'
  spec.add_runtime_dependency 'rspec-expectations', '~> 2.14', '>= 2.14.4'
  spec.add_runtime_dependency 'syntax', '~> 1.2', '>= 1.2.0'
  spec.add_runtime_dependency 'thor', '~> 0.19', '>= 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.6', '>= 1.6.3'
  spec.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7.4'
  spec.add_development_dependency 'redcarpet', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'rubocop', '~> 0.29.1'
  spec.add_development_dependency 'rspec-mocks', '~> 2.14', '>= 2.14.4'
end
