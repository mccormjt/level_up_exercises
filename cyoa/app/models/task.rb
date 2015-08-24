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

  after_create :send_creation_sms_to_owner
  after_create :send_new_task_sms_to_recipients

  include TwilioTask

  def self.build
    new.assignments.build
  end

  def decorator_due_date
    return 'Today' if Date.today == due_date
    return 'Tomorrow' if Date.tomorrow == due_date
    due_date
  end
end
