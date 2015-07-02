@integration
Feature: Recording of headless sessions

  As a developer writing and running headless tests, it would be helpful to
  have a video recording of the session so that troubleshooting/debugging
  failures can be done more easily.

  Background:
    Given I have `Xvfb` installed
      And I have `avconv` installed
      And I have configured my environment from `ENV` and with:
      """
      headless: true
      headless_display: 20
      headless_capture_path: tmp/log
      """
      And the "tmp/log" directory exists

  Scenario: A video file is saved upon teardown for failed scenarios
    Given the current scenario name is "Some scenario"
      And I have started a browser
    When the scenario fails
    Then the file "tmp/log/Some scenario.mp4" should exist

  Scenario: A video file is not saved for passing scenarios
    Given the current scenario name is "Some scenario"
      And I have started a browser
    When the scenario passes
    Then the file "tmp/log/Some scenario.mp4" should not exist

  Scenario: A video per session is saved
    Given the current scenario name is "Some scenario"
      And I have started a browser
      And the scenario fails
      And the next scenario begins
      And the current scenario name is "Some other scenario"
      And I have started a browser
    When the scenario fails
    Then the file "tmp/log/Some scenario.mp4" should exist
      And the file "tmp/log/Some other scenario.mp4" should exist
