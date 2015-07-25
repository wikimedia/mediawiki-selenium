Given(/^I am using the login helper$/) do
  @env.extend(MediawikiSelenium::LoginHelper)
end

When(/^I log in via the helper method$/) do
  @env.log_in
end

Then(/^I should be logged in to the wiki$/) do
  expect(@env.browser.element(id: 'pt-logout')).to be_present
end
