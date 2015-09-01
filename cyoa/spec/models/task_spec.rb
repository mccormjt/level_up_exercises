require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:user) }

  it { should have_many(:assignments) }

  it { should have_many(:recipients) }

  it { should accept_nested_attributes_for(:assignments) }

  it { should validate_presence_of(:user) }

  it { should validate_presence_of(:subject) }

  it { should validate_presence_of(:estimated_completion_hours) }

  it { should validate_presence_of(:description) }

  it { should validate_presence_of(:assignments).with_message('Must have at least 1 recipient') }

  it { should validate_numericality_of(:estimated_completion_hours).is_greater_than(0) }

  it 'should validate due date to be on or after today' do
    task = build(:task, due_date: Faker::Time.backward(30))
    expect(task.valid?).to be false
    error_msg = task.errors.full_messages.join
    expect(error_msg).to include('Due date must be on or after')
  end

  it 'should prevent duplicate assignments from being created if supplied with duplicate recipients' do
    num_recipients = 3
    task = create(
      :task_with_duplicate_recipients,
      num_recipients: num_recipients,
      num_duplicate_recipients: 4,
    )
    expect(task.recipients.size).to eq num_recipients
    expect(task.assignments.size).to eq num_recipients
  end

  it 'should be able to create a new task message that contains related task details' do
    task = create(:task)
    recipient_name = build(:recipient).name
    new_task_msg = task.send(:new_task_msg_for, recipient_name)

    expect(new_task_msg).to include(task.user.name)
    expect(new_task_msg).to include(recipient_name)
    expect(new_task_msg).to include(task.subject)
    expect(new_task_msg).to include(task.description)
    expect(new_task_msg).to include(task.decorator_due_date)
  end

  describe 'decorator due date' do
    it 'should say "Tomorrow" if the due date is the next day' do
      task = build(:task, due_date: Date.tomorrow)
      expect(task.decorator_due_date).to eq 'Tomorrow'
    end

    it 'should say "Today" if the due date is that day' do
      task = build(:task, due_date: Date.today)
      expect(task.decorator_due_date).to eq 'Today'
    end

    it 'should default to a normalized date string if the due date is more than a day in the future' do
      due = Faker::Time.between(2.days.from_now, 1.year.from_now)
      task = build(:task, due_date: due)
      expect(task.decorator_due_date).to include(due.day.to_s)
    end
  end

  describe 'sending post creation SMS messages', skip_before: true do
    it 'should send a verification SMS to the task owner and each recipient after creation' do
      task = build(:task)
      expect(task).to receive(:send_creation_sms_to_owner)
      expect(task).to receive(:send_new_task_sms_to_recipients)
      task.recipients.each do |recipient|
        expect(recipient).to receive(:send_sms)
      end
      task.save!
    end
  end

  describe 'detailed task message' do
    let(:task) { create(:task) }

    before(:each) do
      @fields = TwilioTask::DETAILS_MSG_FIELD_DEFAULTS
    end

    after(:each) do
      details_msg = task.details_msg(@fields)
      @fields[:decorator_due_date] = @fields.delete(:due_date)

      @fields.each do |field, has_included|
        field_val = task.public_send(field).to_s
        has_included_field = details_msg.include?(field_val)
        expect(has_included_field).to be has_included
      end
    end

    it { 'should include default task fields' }

    it 'should be able to only include one field' do
      @fields[:subject] = true
      @fields[:description] = false
      @fields[:due_date] = false
    end

    it 'should be able all but one field' do
      @fields[:subject] = false
      @fields[:description] = true
      @fields[:due_date] = true
    end

    it 'should be able to disclude all fields' do
      @fields[:subject] = false
      @fields[:description] = false
      @fields[:due_date] = false
    end
  end
end
