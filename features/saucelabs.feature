Feature: Remote browser sessions through SauceLabs

  Background:
    Given I have configured my environment from `ENV`
      And I have set "sauce_ondemand_username"
      And I have set "sauce_ondemand_access_key"

  Scenario: SauceLabs sessions start just like a normal browser
    When I start interacting with the browser
    Then the browser is open
