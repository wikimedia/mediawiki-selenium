@integration
Feature: User factory

  Background:
    Given I have configured my environment from `ENV` and with:
      """
      user_factory: true
      """
      And I have set "MEDIAWIKI_URL" in my shell
      And I am using the user factory

  Scenario: User factory creates the primary account
    When I reference the primary user
    Then an account for the user should exist
      And the user name should start with "User-"

  Scenario: User factory creates an alternative account
    When I reference user "some_user"
    Then an account for the user should exist
      And the user name should start with "User-some-user-"
