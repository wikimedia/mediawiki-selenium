Feature: Remote browser sessions through SauceLabs

  Background:
    Given I have configured my environment from `ENV` and with:
      """
      browser: firefox
      platform: linux
      """
      And I have set "SAUCE_ONDEMAND_USERNAME" in my shell
      And I have set "SAUCE_ONDEMAND_ACCESS_KEY" in my shell

  Scenario: SauceLabs sessions start just like a normal browser
    When I start interacting with the browser
    Then the browser is open

  Scenario: Failed scenarios mark SauceLabs jobs as failed
    Given I have started interacting with the browser
    When the scenario fails
    Then the SauceLabs job should be marked as failed
