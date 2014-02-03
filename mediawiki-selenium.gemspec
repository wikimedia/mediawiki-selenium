# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mediawiki/selenium/version'

Gem::Specification.new do |spec|
  spec.name          = "mediawiki-selenium"
  spec.version       = Mediawiki::Selenium::VERSION
  spec.authors       = ["Chris McMahon", "Jeff Hall", "Nikolas Everett", "Tobias Gritschacher", "Željko Filipin"]
  spec.email         = ["cmcmahon@wikimedia.org", "jhall@wikimedia.org", "neverett@wikimedia.org", "tobias.gritschacher@wikimedia.de", "zeljko.filipin@gmail.com"]
  spec.description   = %q{Several MediaWiki extensions share code that makes it easy to run Selenium tests. This gem
makes it easy to update the shared code.}
  spec.summary       = %q{An easy way to run MediaWiki Selenium tests.}
  spec.homepage      = "https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium"
  spec.license       = "GPL-2"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cucumber", "~> 1.3.10"
  spec.add_runtime_dependency "headless", "~> 1.0.1"
  spec.add_runtime_dependency "json", "~> 1.8.1"
  spec.add_runtime_dependency "net-http-persistent", "~> 2.9.1"
  spec.add_runtime_dependency "page-object", "~> 0.9.5"
  spec.add_runtime_dependency "rest-client", "~> 1.6.7"
  spec.add_runtime_dependency "rspec-expectations", "~> 2.14.4"
  spec.add_runtime_dependency "syntax", "~> 1.2.0"
end
