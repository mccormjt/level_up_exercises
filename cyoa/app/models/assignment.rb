class Assignment < ActiveRecord::Base
  FOLLOWUP_TIME_REDUCTION_FACTOR = 7
  MIN_FOLLOW_UP_HOURS = 6

  belongs_to :task, inverse_of: :assignments
  belongs_to :recipient, inverse_of: :assignments

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
              "#{task.subject}? Remember its due #{task.decorator_due_date}!"

    message += status_reply_options
    send_sms(message)
  end

  def followup_hours
    read_attribute(:followup_hours).try(:hours)
  end

  private

  def status_reply_options
    "\n\nTaskID: #{guid} "\
    "\nTo update your status, "\
    "reply \"STATUS\" followed by the taskID, "\
    "and one of the status IDs below:"\
    "\n\nA = UNSTARTED "\
    "\nB = STARTED "\
    "\nC = BLOCKED "\
    "\nD = COMPLETED "\
    "\n\nFormat: STATUS <taskID> <statusID> - <optional message>"\
    "\n\n Ex: \"STATUS #{guid} C - I am blocked until you get me the spreadsheets\""
  end

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
    assignments = recipient.unarchived_assignments.order(:guid)
    assignments.each_with_index do |assignment, index|
      return index unless index == assignment.guid
    end
    assignments.size
  end
end
