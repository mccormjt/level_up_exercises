FactoryGirl.define do
  factory :recipient do
    name { Faker::Name.name }
    phone_number
    user
  end
end