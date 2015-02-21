Given(/^I am logged in(?: as (\w+))$/) do |user|
  as_user(user) do |user, password|
    visit(LoginPage).login_with(user, password)
  end
end
