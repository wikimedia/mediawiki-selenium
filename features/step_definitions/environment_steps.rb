Given(/^I have configured my environment with:$/) do |yaml|
  @env = MediawikiSelenium::Environment.new(YAML.load(yaml))
end

Given(/^I have configured my environment from `ENV`(?: and with:)?$/) do |*args|
  configs = [ENV]
  configs << YAML.load(args.first) if args.length > 0

  @env = MediawikiSelenium::Environment.new(*configs)
end

Given(/^I have set "(.*?)" in my shell$/) do |var|
  begin
    @env.lookup(var)
  rescue MediawikiSelenium::ConfigurationError
    pending "you must configure #{var.upcase} to run this test"
  end
end

After do
  @env.teardown unless @env.nil?
end
