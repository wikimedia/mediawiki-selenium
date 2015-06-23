@integration
Feature: Basic usage

  Background:
    Given I have configured my environment from `ENV` and with:
      """
      browser: phantomjs
      """
      And I have set "MEDIAWIKI_URL" in my shell
      And I am using a local browser

  Scenario: The configured browser is used
    When I start interacting with the browser
    Then the browser name is `:phantomjs`

  Scenario: Browsers are started on-demand
    When I start interacting with the browser
    Then the browser is open

  Scenario: Browsers are closed automatically
    Given I have started a browser
    When teardown is called
    Then the browser should have closed

  Scenario: Navigating to the wiki
    When I navigate to the `wiki_url`
    Then the wiki page should have loaded
