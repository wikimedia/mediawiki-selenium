Before do
  @tmp_files = []
end

After do
  @env.teardown unless @env.nil?
  @tmp_files.each { |path| FileUtils.rm_r(path) if File.exist?(path) }
end

Given(/^I have configured my environment with:$/) do |yaml|
  @configs = [YAML.load(yaml)]
  @env = MediawikiSelenium::Environment.new(*@configs)
end

Given(/^I have configured my environment from `ENV`(?: and with:)?$/) do |*args|
  @configs = [ENV]
  @configs << YAML.load(args.first) if args.length > 0

  @env = MediawikiSelenium::Environment.new(*@configs)
end

Given(/^I have set "(.*?)" in my shell$/) do |var|
  begin
    @env.lookup(var)
  rescue MediawikiSelenium::ConfigurationError
    pending "you must configure #{var.upcase} to run this test"
  end
end

Given(/^I have `(.*?)` installed$/) do |cmd|
  unless system("which #{cmd} > /dev/null") == true
    pending "you must have #{cmd} installed to run this test"
  end
end

Given(/^the "(.*?)" directory exists$/) do |dir|
  @tmp_files << dir unless File.exist?(dir)
  FileUtils.mkdir_p(dir)
end

Given(/^the environment has been setup$/) do
  @env.setup
end

Given(/^the current scenario name is "(.*?)"$/) do |name|
  @scenario_name = name
end

Given(/^the next scenario begins$/) do
  @env = MediawikiSelenium::Environment.new(*@configs)
end

When(/^the scenario ends$/) do
  begin
    # Avoid a race condition within the headless video recorder by waiting
    sleep 0.3
    @env.teardown(name: @scenario_name, status: @scenario_status)
  ensure
    @env = nil
  end
end

When(/^the scenario (fails|passes)$/) do |status|
  @scenario_status = status == 'fails' ? :failed : :passed
  step 'the scenario ends'
end

Then(/^the file "(.*?)" should (not )?exist$/) do |file, negate|
  expect(Pathname.new(file)).send(negate ? :to_not : :to, exist)
end
