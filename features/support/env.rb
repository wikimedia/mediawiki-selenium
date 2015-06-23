require 'rspec/mocks'
require 'mediawiki_selenium'

World(RSpec::Mocks::ExampleMethods)

Before { RSpec::Mocks.setup }
After { RSpec::Mocks.teardown }
