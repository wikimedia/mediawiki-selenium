Given(/^I am using the API helper$/) do
  @env.extend(MediawikiSelenium::ApiHelper)
end

When(/^I access the API helper$/) do
  @env.api
end

Then(/^the API client should have authenticated$/) do
  expect(@env.api).to be_logged_in
end
