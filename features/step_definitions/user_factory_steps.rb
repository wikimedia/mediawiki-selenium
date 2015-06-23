Given(/^I am using the user factory$/) do
  @env.extend(MediawikiSelenium::ApiHelper, MediawikiSelenium::UserFactoryHelper)
end

When(/^I reference the primary user$/) do
  @user = @env.user
end

When(/^I reference user "(.*?)"$/) do |id|
  @user = @env.user(id)
end

Then(/^an account for the user should exist$/) do
  @users = @env.api.query(list: 'users', ususers: @user).data['users']

  expect(@users).to be_a(Array)
  expect(@users.first).to include('name')
end

Then(/^the user name should start with "(.*?)"$/) do |prefix|
  expect(@users.first['name']).to start_with(prefix)
end
