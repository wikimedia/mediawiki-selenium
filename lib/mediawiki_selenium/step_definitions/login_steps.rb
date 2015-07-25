Given(/^I am logged in(?: as (\w+))?$/) do |user|
  as_user(user) { log_in }
end
