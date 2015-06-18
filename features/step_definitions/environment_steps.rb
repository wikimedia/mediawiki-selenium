Given(/^I have configured my environment with:$/) do |config|
  @env = MediawikiSelenium::Environment.new(config.rows_hash)
end

Given(/^I have configured my environment from `ENV`(?: and with:)?$/) do |*args|
  configs = [ENV]
  configs << args.first.rows_hash if args.length > 0

  @env = MediawikiSelenium::Environment.new(*configs)
end

Given(/^I have set "(.*?)"$/) do |var|
  begin
    @env.lookup(var)
  rescue MediawikiSelenium::ConfigurationError
    pending "you must configure #{var.upcase} to run this test"
  end
end

After do
  @env.teardown unless @env.nil?
end
