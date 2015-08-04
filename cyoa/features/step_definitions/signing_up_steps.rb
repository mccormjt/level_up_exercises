Given(/^I am on the home page$/) do
  visit('/')
end

When(/^I click the signup button$/) do
  click_on('Signup')
end

Then(/^I should see the signup form$/) do
  page.should have_css('.signup.active')
end

When(/^I submit the signup form with valid fields$/) do
  signup_with_valid_fields
end

Then(/^I should see my dashboard$/) do
  page.should have_css('.dashboard')
end

When(/^I submit the signup form without a name$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a "(.*?)" form warning$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I submit the signup form with too short of a phone number$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I submit the signup form with too short of a password$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I submit the signup form with mismatching passwords$/) do
  pending # express the regexp above with the code you wish you had
end

def signup_with_valid_fields
  submit_signup_form_with(name: 'John Mac', phone_number: '5617129945',
                          password: 's3cret', confirm_password: 's3cret')
end

def submit_signup_form_with(fields={})
  fill_in('user[name]', with: fields[:name])
  fill_in('user[phone_number]', with: fields[:phone_number])
  fill_in('user[password]', with: fields[:password])
  fill_in('user[password_confirmation]', with: fields[:confirm_password])
  click_on('Go')
end