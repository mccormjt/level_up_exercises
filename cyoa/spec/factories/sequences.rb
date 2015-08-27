FactoryGirl.define do
  sequence :phone_number do |n|
    needed_digits = 7 - n.to_s.size
    digits = Faker::Number.number(needed_digits)
    "1561#{digits}#{n}"
  end
end