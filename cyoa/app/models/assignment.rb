class Assignment < ActiveRecord::Base
  belongs_to :task, inverse_of: :assignments
  belongs_to :recipient, inverse_of: :assignments

  validates_presence_of :task, :recipient
end
