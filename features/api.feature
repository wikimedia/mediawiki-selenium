@integration
Feature: MW API helper

  Background:
    Given I have configured my environment from `ENV` and with:
      """
      user_factory: true
      """
      And I have set "MEDIAWIKI_URL" in my shell
      And I am using the user factory
      And I am using the API helper

  Scenario: API helper automatically authenticates
    When I access the API helper
    Then the API client should have authenticated
