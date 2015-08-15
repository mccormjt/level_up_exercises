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

  def self.build
    task = self.new
    task.assignments.build
  end

  def self.recieved_by(phone_number)
    query = {'recipients.phone_number' => phone_number}
    @tasks = joins(:assignments, :recipients).where(query)
  end

  def self.sent_by(user_id)
    @tasks = where(user_id: user_id)
  end

  def self.archived_by(user_id)
    @tasks = where(user_id: user_id)
  end

  def self.expand_into_detailed_assignments
    @tasks.collect(&:detailed_assignments).flatten
  end

  def detailed_assignments
    assignments.collect do |assignment|
      {
        to: assignment.recipient.name,
        from: user.name,
        subject: subject,
        due_date: decorator_due_date,
      }
    end
  end

  def decorator_due_date
    return 'Today' if Date.today == due_date
    return 'Tomorrow' if Date.tomorrow == due_date
    due_date
  end
end
