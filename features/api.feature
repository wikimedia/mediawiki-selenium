Feature: MW API helper

  Background:
    Given I have configured my environment from `ENV` and with:
      | mediawiki_url  | http://en.wikipedia.beta.wmflabs.org/w/api.php |
      | mediawiki_user | Selenium user                                  |
      And I am using the API helper

  Scenario: API helper automatically authenticates
    Given I have set "mediawiki_password"
    When I access the API helper
    Then the API client should have authenticated
