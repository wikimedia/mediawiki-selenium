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
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
