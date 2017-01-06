require 'yaml'
require 'open3'

Given(/^I have set up my `environments\.yml`$/) do
  step 'the "tmp/rspec/spec" directory exists'
  File.open('tmp/rspec/environments.yml', 'w') { |io| io.write(YAML.dump({ 'default' => {} })) }
end

Given(/^the following RSpec support file:$/) do |content|
  File.open('tmp/rspec/spec/spec_helper.rb', 'w') { |io| io.write(content) }
end

Given(/^the following RSpec examples:$/) do |content|
  content = "require 'spec_helper'\n#{content}"
  File.open('tmp/rspec/spec/examples_spec.rb', 'w') { |io| io.write(content) }
end

Given(/^$the following "(.+)" file for use with RSpec$/) do |path, content|
  File.open(File.join('tmp/rspec', path), 'w') { |io| io.write(content) }
end

When(/^I run `rspec` against my examples$/) do
  env = { 'MEDIAWIKI_ENVIRONMENT' => 'default' }
  cmd = 'bundle exec rspec'

  @rspec_output, @rspec_status = Open3.capture2e(env, cmd, chdir: 'tmp/rspec')
end

Then(/^I should see (\d+) passing examples?$/) do |n|
  expect(@rspec_status).to be_success, "Examples did not pass. Output:\n---\n#{@rspec_output}---\n"
  expect(@rspec_output).to match(/^#{n} examples?, 0 failures/)
end
