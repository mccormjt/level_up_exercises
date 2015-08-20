class StatusResponseHandler < TwilioResponseHandler
  def respond
    # TODO
  end

  def self.description
    "STATUS <taskID> <statusID> - <optional Message> - "\
    "updates the task assigner with your current status for a specific task. "\
    "\nStatus IDs: A = UNSTARTED, B = STARTED, C = BLOCKED, D = FINISHED "\
    "\n\"Ex: STATUS 3 B - starting the paper work now Bill\""
  end
end