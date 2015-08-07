Then(/^I should see an? "(.*?)" (.*?) alert$/) do |msg, type_class|
  within(".alert-#{type_class}") do
    expect(page).to have_content(/#{msg}/i)
  end
end
