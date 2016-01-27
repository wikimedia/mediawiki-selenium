Given(/^I am using the embed browser session helper$/) do
  @env.extend(MediawikiSelenium::EmbedBrowserSession)
end
