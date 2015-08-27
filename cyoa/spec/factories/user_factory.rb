FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    phone_number
    password Faker::Internet.password(10)
  end
end
