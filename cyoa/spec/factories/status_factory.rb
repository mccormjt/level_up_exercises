FactoryGirl.define do
  factory :status do
    assignment
    message Faker::Lorem.paragraph
    created_at { Faker::Time.backward(30) }

    state do
      Status.states.values.sample
    end

    factory :unstarted_status do
      state :unstarted
    end

    factory :started_status do
      state :started
    end

    factory :blocked_status do
      state :blocked
    end

    factory :completed_status do
      state :completed
    end
  end
end