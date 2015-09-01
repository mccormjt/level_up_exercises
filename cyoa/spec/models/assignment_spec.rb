require 'rails_helper'

RSpec.describe Assignment, type: :model do
  let(:task) { create(:task) }
  let(:user) { create(:user) }
  let(:assignment) { task.assignments.first }

  it { should belong_to(:task) }

  it { should belong_to(:recipient) }

  it { should have_many(:statuses) }

  it { should validate_presence_of(:task) }

  it { should validate_presence_of(:recipient) }

  it { should delegate_method(:name).to(:recipient) }

  it { should delegate_method(:phone_number).to(:recipient) }

  it { should delegate_method(:user).to(:task) }

  it 'should be able to find all assignments sent to a specific phone_number' do
    recipients = create_list(:recipient, 3)
    phone = recipients.first.phone_number
    num_tasks = 3
    create_list(:task, num_tasks, recipients: recipients)
    expect(Assignment.recieved_by(phone).size).to eq num_tasks
  end

  it 'should be able to find all assignments sent by a specific user_id' do
    num_tasks = 3
    num_recipients = 2
    num_assignments = num_tasks * num_recipients
    create_list(:task, num_tasks, user: user, num_recipients: num_recipients)
    expect(Assignment.sent_by(user.id).size).to eq num_assignments
  end

  it 'should be able to find all assignments related to either a given user_id or phone_number' do
    num_recieved_tasks = 3
    num_sent_tasks = 3
    num_sent_recipients = 2
    num_sent_assignments = num_sent_tasks * num_sent_recipients
    total_assignments = num_recieved_tasks + num_sent_assignments

    create_list(:task, num_sent_tasks, user: user, num_recipients: num_sent_recipients)
    user_recipient = create_list(:recipient, 1, phone_number: user.phone_number)
    create_list(:task, num_recieved_tasks, recipients: user_recipient)
    related_assignments = Assignment.related_to(user.id, user.phone_number)

    expect(related_assignments.size).to eq total_assignments
  end

  it 'should be able to consolidate all of its related task details' do
    expect(assignment.expanded_task_details).to include(
      :task_id,
      :assignment_id,
      :to,
      :from,
      :subject,
      :description,
      :due_date,
      :status_state,
    )
  end

  it 'should assign itself a guid after creation' do
    expect(assignment.guid).to_not be_nil
  end

  it 'should assign itself the next possible smallest guid after creation relative to that recipient' do
    guid = 3
    recipient = create_list(:recipient, 1)
    create_list(:task, 5, recipients: recipient)
    Assignment.find_by_guid(guid).destroy
    task = create(:task, recipients: recipient)
    new_guid = task.assignments.first.guid
    expect(new_guid).to eq guid
  end

  it 'should be able to destroy all archived assignments that have gone stale' do
    num_new_assignments  = 2
    num_stale_assignments = 3
    num_stale_archived_assignments = 4
    num_preserved_assignments = num_new_assignments + num_stale_assignments

    task
    Assignment.destroy_all
    create_list(:assignment, num_new_assignments, task: task)
    create_list(:stale_assignment, num_stale_assignments, task: task)
    create_list(:stale_archived_assignment, num_stale_archived_assignments, task: task)

    Assignment.destroy_stale_archived
    expect(Assignment.all.size).to eq num_preserved_assignments
  end

  it 'should initialize with no statuses' do
    expect(assignment.statuses).to be_empty
  end

  it 'should initialize with an unstarted decorator current status state' do
    expect(assignment.current_status_state_decorator).to eq Status::UNSTARTED
  end

  it 'should list statuses starting with the most recent' do
    create_list(:status, 10, assignment: assignment)
    statuses = assignment.statuses
    first_created_at = statuses.first.created_at
    last_created_at = statuses.last.created_at
    expect(first_created_at).to be > last_created_at
  end

  it 'can be archived' do
    expect(assignment).to receive(:send_archived_msg)
    assignment.archive!
    expect(assignment.archived?).to be true
  end

  it 'should send the user and recipients SMS notifications when archived', skip_before: true do
    expect(assignment).to receive(:send_sms).with(instance_of(String))
    expect(assignment).to receive(:send_user_sms).with(instance_of(String))
    assignment.archive!
  end
end
