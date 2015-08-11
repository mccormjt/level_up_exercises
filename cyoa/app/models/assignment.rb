class Assignment < ActiveRecord::Base
  belongs_to :task
  belongs_to :recipient
end
