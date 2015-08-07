Given(/^I am logged into my dashboard$/) do
  signup_with_valid_fields
end

Given(/^I am on the home page$/) do
  visit('/')
end

When(/^I click the signup button$/) do
  click_on('Signup')
end

Then(/^I should see the signup form$/) do
  expect(page).to have_css('.signup.active')
end

When(/^I submit the signup form with valid fields$/) do
  signup_with_valid_fields
end

Then(/^I should see my dashboard$/) do
  expect(page).to have_css('.dashboard')
end

When(/^I submit the signup form without a name$/) do
  signup_with_valid_fields(name: '')
end

When(/^I submit the signup form with an invalid phone number$/) do
  signup_with_valid_fields(phone_number: '1234567')
end

When(/^I submit the signup form with too short of a password$/) do
  signup_with_valid_fields(password: 's3cret', confirm_password: 's3cret')
end

When(/^I submit the signup form with mismatching passwords$/) do
  signup_with_valid_fields(password: 's3cret123489', confirm_password: 'a-different-password-123')
end

def signup_with_valid_fields(field_overrides={})
  fields = { name: 'John Mac', phone_number: '15617129946',
            password: 's3cret1234', confirm_password: 's3cret1234' }

  submit_signup_form_with(fields.merge(field_overrides))
end

def submit_signup_form_with(fields={})
  fill_in('user[name]', with: fields[:name])
  fill_in('user[phone_number]', with: fields[:phone_number])
  fill_in('user[password]', with: fields[:password])
  fill_in('user[password_confirmation]', with: fields[:confirm_password])
  click_on('Go')
end
