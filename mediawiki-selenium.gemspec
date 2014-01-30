# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mediawiki/selenium/version'

Gem::Specification.new do |spec|
  spec.name          = "mediawiki-selenium"
  spec.version       = Mediawiki::Selenium::VERSION
  spec.authors       = ["Zeljko Filipin"]
  spec.email         = ["zeljko.filipin@gmail.com"]
  spec.description   = %q{Several MediaWiki extensions share code that makes it easy to run Selenium tests. This gem
makes it easy to update the shared code.}
  spec.summary       = %q{An easy way to run MediaWiki Selenium tests.}
  spec.homepage      = "https://gerrit.wikimedia.org/r/#/admin/projects/mediawiki/selenium"
  spec.license       = "GPL-2"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cucumber"
  spec.add_runtime_dependency "headless", '~> 0'
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "net-http-persistent"
  spec.add_runtime_dependency "page-object"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "rspec-expectations"
  spec.add_runtime_dependency "syntax"
end
