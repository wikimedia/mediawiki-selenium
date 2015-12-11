require 'net/https'

Given(/^I have configured my environment to use (.*?) on (.*?)$/) do |browser, platform|
  @configs = [ENV, { browser: browser, platform: platform, browser_timeout: 120 }]
  @env = MediawikiSelenium::Environment.new(*@configs)
end

Then(/^the SauceLabs job should be marked as failed$/) do
  job_id = @env.browser.driver.session_id

  username = @env[:sauce_ondemand_username]
  access_key = @env[:sauce_ondemand_access_key]

  job_uri = URI.parse("https://saucelabs.com/rest/v1/#{username}/jobs/#{job_id}")

  job_uri.user = username
  job_uri.password = access_key

  job = JSON.parse(Net::HTTP.get(job_uri))

  expect(job).to include('passed')
  expect(job['passed']).to be(false)
end
