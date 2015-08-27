FactoryGirl.define do
  factory :assignment do
    task
    recipient

    after(:build) do |assignment|
      assignment.send(:update_next_followup_time)
    end

    trait :stale do
      updated_at { Assignment::ARCHIVED_STALE_TIME - 1.day }
    end

    trait :archived do
      archived true
    end

    factory :stale_assignment, traits: [:stale]
    factory :stale_archived_assignment, traits: [:stale, :archived]
  end
end
