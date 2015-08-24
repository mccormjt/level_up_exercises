module TwilioAssignment
  include SmsSendable

  def send_followup_msg
    message = "Hello #{name}, \"FollowUp\" here. What should we tell "\
              "#{task.user.name} your status is with your task regarding: "\
              "#{task.subject}? Remember its due #{task.decorator_due_date}!\n\n"

    message << StatusResponseHandler.call_to_action
    send_sms(message)
  end

  def send_archived_msg
    msg = "The following task has been ARCHIVED and "\
          "will no longer be followed up with:"\
          "\n#{task.details_msg}"

    send_sms(msg)
    user.send_sms(msg)
  end

  def preview_task_msg
    preview_details = task.details_msg(description: false)
    "\n\nTASK_ID: #{guid} #{preview_details}"
  end
end
