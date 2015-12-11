Feature: Support for entire suite of browsers provided by SauceLabs
  Background:
    Given I have configured my environment from `ENV`
      And I have set "SAUCE_ONDEMAND_USERNAME" in my shell
      And I have set "SAUCE_ONDEMAND_ACCESS_KEY" in my shell

  Scenario Outline: All SauceLabs browsers are supported
    Given I have configured my environment to use <browser> on <platform>
    When I start interacting with the browser
    Then the browser is open

  Examples:
    | browser           | platform   |
    | firefox           | linux      |
    | firefox           | windows    |
    | chrome            | linux      |
    | chrome            | windows    |
    | internet_explorer | windows    |
    | safari            | os x 10.11 |
    | android           | linux      |
    | iphone            | os x 10.11 |
