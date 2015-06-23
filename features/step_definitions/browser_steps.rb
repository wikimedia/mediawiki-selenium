require 'uri'

Given(/^I have started a browser$/) do
  @env.browser
end

Given(/^I am using a local browser$/) do
  allow(@env).to receive(:remote?).and_return(false)
end

When(/^I start interacting with the browser$/) do
  @env.browser
end

When(/^I navigate to the `wiki_url`$/) do
  @env.browser.goto @env.wiki_url
end

When(/^teardown is called$/) do
  @env.teardown
end

Then(/^the browser is open$/) do
  expect(@env.browser).to exist
end

Then(/^the wiki page should have loaded$/) do
  expect(@env.browser.element(tag_name: 'body', class: 'mediawiki')).to be_present
end

Then(/^the browser should have closed$/) do
  expect(@env.browser).to_not exist
end

Then(/^the browser name is `:(.*?)`$/) do |type|
  expect(@env.browser.name).to eq(type.to_sym)
end
