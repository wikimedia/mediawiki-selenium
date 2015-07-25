Feature: Login Helper

  Background:
    Given I have configured my environment from `ENV` and with:
      """
      user_factory: true
      """
      And I have set "MEDIAWIKI_API_URL" in my shell
      And I have set "MEDIAWIKI_URL" in my shell
      And I am using the user factory
      And I am using the login helper

  Scenario: Login helper logs in in via the API
    When I log in via the helper method
    Then I should be logged in to the wiki
