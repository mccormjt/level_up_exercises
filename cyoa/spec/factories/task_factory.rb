FactoryGirl.define do
  factory :task do
    user
    due_date { Faker::Date.forward(60) }
    subject Faker::Lorem.paragraph(1)
    description Faker::Lorem.paragraph
    estimated_completion_hours Faker::Number.between(1, 100)

    transient do
      num_recipients 3
      recipients { create_list(:recipient,  num_recipients) }
    end

    after(:build) do |task, evaluator|
      assignment_attrs = {}
      evaluator.recipients.each_with_index.map do |recipient, index|
        assignment_attrs[index] = { recipient_id: recipient.id }
      end
      task.assignments_attributes = assignment_attrs
    end

    after(:create) do |task|
      task.assignments.each { |task| task.send(:update_next_followup_time) }
    end

    factory :overdue_task do
      due_date Faker::Time.backward(60)
    end

    factory :task_with_duplicate_recipients do
      transient do
        num_duplicate_recipients 3

        recipients do
          recipients = create_list(:recipient, num_recipients)
          num_duplicate_recipients.times { recipients.push(recipients.first) }
          recipients
        end
      end
    end
  end
end
