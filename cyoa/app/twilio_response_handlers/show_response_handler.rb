class ShowResponseHandler < TwilioResponseHandler
  def respond
    msg = unknown_task_msg
    msg ||= task_details_msg
    send_sms(msg)
  end

  def self.call_to_action
    "Reply SHOW <taskID> - to get full details for a specific task.\n\"Ex: SHOW 2\""
  end

  private

  def task_details_msg
    "Hi #{recipient.name}, your were assigned this task by your "\
    "contact #{task.user.name}."\
    "\n\nTASK_ID: #{assignment_guid} #{task.details_msg}"\
    "\n\n#{StatusResponseHandler.call_to_action(assignment_guid)}"
  end

  def unknown_task_msg
    "Sorry, you don't have an active task assigned "\
    "to you with the ID provided: #{assignment_guid}" unless task
  end
end