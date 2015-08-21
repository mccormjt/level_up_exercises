class Assignment < ActiveRecord::Base
  FOLLOWUP_TIME_REDUCTION_FACTOR = 7
  MIN_FOLLOW_UP_HOURS = 6

  belongs_to :task, inverse_of: :assignments
  belongs_to :recipient, inverse_of: :assignments
  has_many :statuses

  validates_presence_of :task, :recipient

  before_create :assign_guid
  after_create :schedule_next_followup

  delegate :name, to: :recipient
  delegate :phone_number, to: :recipient

  include SmsSendable

  def schedule_next_followup
    update_next_followup_time
    FollowupWorker.perform_in(followup_hours, id)
  end

  def followup
    message = "Hello #{name}, \"FollowUp\" here. What should we tell "\
              "#{task.user.name} your status is with your task regarding: "\
              "#{task.subject}? Remember its due #{task.decorator_due_date}!\n\n"

    message << StatusResponseHandler.call_to_action
    send_sms(message)
  end

  def followup_hours
    read_attribute(:followup_hours).try(:hours)
  end

  def preview_task_msg
    preview_details = task.details_msg(description: false)
    "\n\nTASK_ID: #{guid} #{preview_details}"
  end

  def latest_status
    statuses.order(created_at: :desc).limit(1).first
  end

  def latest_decorator_status_state
    latest_status.try(:decorator_state) || Status::UNSTARTED
  end

  private

  def update_next_followup_time
    due_days = task.due_date - Date.today
    followup_days = (due_days.to_f / FOLLOWUP_TIME_REDUCTION_FACTOR).ceil
    followup_hrs = followup_days * 24
    followup_hrs = [followup_hrs, MIN_FOLLOW_UP_HOURS].max
    # followup_hrs = 0.007
    update(followup_hours: followup_hrs)
  end

  def assign_guid
    write_attribute(:guid, next_smallest_guid)
  end

  def next_smallest_guid
    assignments = recipient.assignments.order(:guid)
    assignments.each_with_index do |assignment, index|
      return index unless index == assignment.guid
    end
    assignments.size
  end
end
