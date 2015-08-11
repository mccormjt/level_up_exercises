class Task < ActiveRecord::Base
  belongs_to :user
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
end
