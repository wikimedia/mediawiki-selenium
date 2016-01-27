Feature: Embedded remote browser session ID for Cucumber tests

  Sessions where an ID is assigned, such as SauceLabs remote sessions, should
  have the ID saved (embedded) by the Cucumber logger. This test doesn't
  actually measure that the session ID was correctly embedded but simply
  exercises the helper to make sure it doesn't blow up when the `#session_id`
  method doesn't exist.

  Scenario: The helper doesn't blow up
    Given I have configured my environment from `ENV`
      And I am using a local browser
      And I am using the embed browser session helper
    When I start interacting with the browser
    Then the browser is open
