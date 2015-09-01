require 'rails_helper'

RSpec.describe Assignment, type: :model do

  it 'should store the next followup time after creation' do
    followup_hours = create(:assignment).followup_hours
    expect(followup_hours).to be > 0
  end

  it 'should have a followup time of 1 day if its due in less than a week' do
    expect_followup_hours_for(
      task_due_date: Faker::Time.between(Date.tomorrow, 1.week.from_now), 
      expected_followup_hours: 1.day,
    )
  end

  it 'should have a followup time of 1 day if its due in exactly one week' do
    expect_followup_hours_for(
      task_due_date: 1.week.from_now, 
      expected_followup_hours: 1.day,
    )
  end

  it 'should have a followup time of 2 days if its due in one to two weeks' do
    expect_followup_hours_for(
      task_due_date: Faker::Time.between(8.days.from_now, 2.weeks.from_now), 
      expected_followup_hours: 2.days,
    )
  end

  it 'should have a followup time of 5 days if its due in four to five weeks' do
    expect_followup_hours_for(
      task_due_date: Faker::Time.between(29.days.from_now, 5.weeks.from_now), 
      expected_followup_hours: 5.days,
    )
  end

  it 'should default to minimum followup time if due date is today' do
    expect_followup_hours_for(
      task_due_date: Date.today, 
      expected_followup_hours: Assignment::MIN_FOLLOW_UP_HOURS.hours,
    )
  end

  it 'should default to minimum followup time if due date has passed' do
    task = build(:overdue_task)
    task.save(validate: false)
    task.assignments.first.send(:update_next_followup_time)

    expect_task_assignment_followup_hours_to_be(
      task,
      Assignment::MIN_FOLLOW_UP_HOURS.hours,
    )
  end


  def expect_followup_hours_for(params={})
    task = create(:task, due_date: params[:task_due_date])
    expect_task_assignment_followup_hours_to_be(
      task,
      params[:expected_followup_hours],
    )
  end

  def expect_task_assignment_followup_hours_to_be(task, hours)
    followup_hours = task.assignments.first.followup_hours
    expect(followup_hours).to eq hours
  end
end
