Feature: Basic usage

  Background:
    Given I have configured my environment with:
      | browser       | phantomjs                                           |
      | mediawiki_url | http://en.wikipedia.beta.wmflabs.org/wiki/Main_page |

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
    Then the current URL should be "http://en.wikipedia.beta.wmflabs.org/wiki/Main_page"
