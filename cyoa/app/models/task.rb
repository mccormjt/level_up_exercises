require 'twilio_task'

class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment
  has_many :recipients, through: :assignments
  has_many :assignments, inverse_of: :task, dependent: :destroy

  accepts_nested_attributes_for :assignments, allow_destroy: true

  validates_presence_of :user, :subject, :estimated_completion_hours, :description
  validates :assignments, presence: { message: 'Must have at least 1 recipient' }
  validates :estimated_completion_hours, numericality: { greater_than: 0 }
  validates_date :due_date, on_or_after: -> { Date.current }

  alias_attribute :archived?, :archived

  after_create :send_creation_sms_to_owner
  after_create :send_creation_sms_to_recipients

  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  include TwilioTask

  class << self
    def build
      new.assignments.build
    end

    def recieved_by(phone_number)
      query = {'recipients.phone_number' => phone_number}
      joins(:assignments, :recipients).where(query)
    end

    def sent_by(user_id)
      where(user_id: user_id)
    end

    def related_to(user_id, phone_number)
      query = 'users.id=? OR recipients.phone_number=?'
      joins(:user, :assignments, :recipients).where(query, user_id, phone_number)
    end

    def expand_into_detailed_assignments(tasks)
      tasks.map(&:detailed_assignments).flatten
    end
  end

  def detailed_assignments
    assignments.map do |assignment|
      {
        id: id,
        to: assignment.recipient.name,
        from: user.name,
        subject: subject,
        due_date: decorator_due_date,
      }
    end
  end

  def archive!
    update(archived: true)
  end

  def decorator_due_date
    return 'Today' if Date.today == due_date
    return 'Tomorrow' if Date.tomorrow == due_date
    due_date
  end
end
