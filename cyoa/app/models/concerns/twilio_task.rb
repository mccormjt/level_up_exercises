module TwilioTask
  TWILIO_PHONE_NUMBER = Cyoa.config.twilio['phone_number']

  @@TwilioClient = Twilio::REST::Client.new

  def send_creation_sms_to_owner
    message = "Hi #{user.name}, your new FollowUp task has\
               been sent to #{recipients.decorator_names}\
               regarding: #{subject}.\
               \n\nWe'll keep you updated with their status, Cheers!"
    send_sms(message, user.phone_number)
  end

  def send_new_task_sms_to_recipients
    recipients.each do |recipient|
      send_sms(recipient_new_task_msg(recipient), recipient.phone_number)
    end
  end

  private

  def recipient_new_task_msg(recipient)
    "Hello #{recipient.name}, your contact #{user.name}\
    has sent you a new TODO task through\
    this automated task 'FollowUp' system.\
    \n\nSUBJECT: #{subject}\
    \n\nDUE: #{decorator_due_date}\
    \n\nDESCRIPTION: #{description}\
    \n\nWe will check back in for status updates\
    every so often until you have completed this task.\
    \nReply HELP for more options"
  end

  def send_sms(message, to_phone_number)
    @@TwilioClient.messages.create(
      from: TWILIO_PHONE_NUMBER,
      to: to_phone_number,
      body: message
    )
  end
end
