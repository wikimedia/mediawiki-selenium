Feature: Remote browser sessions through SauceLabs

  Background:
    Given I have configured my environment from `ENV` and with:
      """
      browser: firefox
      platform: linux
      """

  Scenario: SauceLabs sessions start just like a normal browser
    Given I have set "SAUCE_ONDEMAND_USERNAME" in my shell
      And I have set "SAUCE_ONDEMAND_ACCESS_KEY" in my shell
    When I start interacting with the browser
    Then the browser is open
