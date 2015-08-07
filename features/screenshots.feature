@integration
Feature: Screenshots of failed scenarios

  As a developer writing and running tests, it would be helpful to have a
  screenshot of the browser window at the point where each scenario has
  failed.

  Background:
    Given I have configured my environment with:
      """
      screenshot_failures: true
      screenshot_failures_path: tmp/screenshots
      """
      And the "tmp/screenshots" directory exists
      And I am using the screenshot helper

  Scenario: A screenshot is taken for failed scenarios
    Given the current scenario name is "Some scenario"
      And I have started a browser
    When the scenario fails
    Then the file "tmp/screenshots/Some scenario.png" should exist
