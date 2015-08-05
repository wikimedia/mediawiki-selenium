require 'net/https'

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
