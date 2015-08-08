@integration
Feature: RSpec integration

  As a developer, I want the option to use a test framework with less
  indirection so that my tests are more straightforward to implement and
  easier to reason about.

  Background:
    Given I have set up my `environments.yml`
      And the following RSpec support file:
      """
      require 'bundler/setup'
      require 'mediawiki_selenium/rspec'
      """

  Scenario: RSpec examples have access to the `Environment` via `#mw`
    Given the following RSpec examples:
    """
    describe 'my feature' do
      describe 'my component' do
        it 'can access `mw` to implement its tests' do
          expect(mw).to be_a(MediawikiSelenium::Environment)
        end
      end
    end
    """
    When I run `rspec` against my examples
    Then I should see 1 passing example

  Scenario: Calls to `mw` methods can be unqualified/indirect
    Given the following RSpec examples:
    """
    describe 'my feature' do
      describe 'my component' do
        it 'can call `mw` methods indirectly via `self`' do
          expect(mw).to respond_to(:on_wiki)
          expect(self).to respond_to(:on_wiki)
        end
      end
    end
    """
    When I run `rspec` against my examples
    Then I should see 1 passing example

  Scenario: An alternative feature/scenario syntax is supported
    Given the following RSpec examples:
    """
    feature 'my feature' do
      background do
        # do common stuff
        @stuff = 'stuff'
      end

      scenario 'my scenario' do
        expect(@stuff).to eq('stuff')
      end

      scenario 'my other scenario' do
        expect(@stuff).to eq('stuff')
      end
    end
    """
    When I run `rspec` against my examples
    Then I should see 2 passing examples
