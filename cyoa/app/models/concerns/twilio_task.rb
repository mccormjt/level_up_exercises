module TwilioTask
  DETAILS_MSG_FIELD_DEFAULTS ||= { subject: true, due_date: true, description: true }
  include SmsSendable

  def send_creation_sms_to_owner
    message = "Hi #{user.first_name}, your new FollowUp task has "\
              "been sent to #{recipients.decorator_names} "\
              "regarding: #{subject}. "\
              "\n\nWe'll keep you updated with their status, Cheers!"
    send_user_sms(message)
  end

  def send_new_task_sms_to_recipients
    assignments.each do |assignment|
      assignment.send_sms(new_task_msg_for(assignment.name))
    end
  end

  def details_msg(fields={})
    fields = DETAILS_MSG_FIELD_DEFAULTS.merge(fields)
    details = ''
    details << "\nSUBJECT: #{subject}" if fields[:subject]
    details << "\nDUE: #{decorator_due_date}" if fields[:due_date]
    details << "\nDESCRIPTION: #{description}" if fields[:description]
    details
  end

  private

  def new_task_msg_for(recipient_name)
    "Hello #{recipient_name}, your contact #{user.name} "\
    "has sent you a new TODO task through "\
    "this automated task \"FollowUp\" system. "\
    "#{details_msg}"\
    "\n\nWe will check back in for status updates "\
    "every so often until you have completed this task. "\
    "\n\n#{OptionsResponseHandler.call_to_action}"
  end
end
