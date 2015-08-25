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
  delegate :user, to: :task

  alias_attribute :archived?, :archived

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  include TwilioAssignment

  class << self
    def recieved_by(phone_number)
      query = {'recipients.phone_number' => phone_number}
      joins(:recipient).where(query)
    end

    def sent_by(user_id)
      query = {'tasks.user_id' => user_id}
      joins(:task).where(query)
    end

    def related_to(user_id, phone_number)
      query = 'tasks.user_id=? OR recipients.phone_number=?'
      joins(:task, :recipient).where(query, user_id, phone_number)
    end

    def expanded_task_details(assignments)
      assignments.map(&:expanded_task_details)
    end
  end

  def schedule_next_followup
    update_next_followup_time
    FollowupWorker.perform_in(followup_hours, id)
  end

  def followup_hours
    read_attribute(:followup_hours).try(:hours)
  end

  def statuses
    super.order(created_at: :desc)
  end

  def current_status
    statuses.limit(1).first
  end

  def current_status_state_decorator
    current_status.try(:decorator_state) || Status::UNSTARTED
  end

  def archive!
    update(archived: true)
    send_archived_msg
  end

  def expanded_task_details
    {
      task_id: task.id,
      assignment_id: id,
      to: recipient.name,
      from: user.name,
      subject: task.subject,
      description: task.description,
      due_date: task.decorator_due_date,
      status_state: current_status_state_decorator,
    }
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
