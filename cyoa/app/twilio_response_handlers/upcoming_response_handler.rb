class UpcomingResponseHandler < TwilioResponseHandler
  NUM_TASKS_TO_DISPLAY = 5

  def respond
    send_sms(upcoming_tasks_msg)
  end

  def self.call_to_action
    "Reply UPCOMING to list the next few upcoming tasks that are due, "\
    "along with their respective Task IDs which can be used with "\
    "other commands such as SHOW <taskID>"
  end

  def upcoming_tasks_msg
    assignments = recipient.try(:upcoming_assignments)
    return no_upcoming_tasks_msg unless assignments.try(:any?)
    message = "Your Upcoming Tasks:"
    assignments.map(&:preview_task_msg).reduce(message, :<<)
  end

  def no_upcoming_tasks_msg
    'You currently do not have any active tasks assigned to you'
  end
end
