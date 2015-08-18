module TwilioTask
  TWILIO_PHONE_NUMBER = Cyoa.config.twilio['phone_number']

  @@TwilioClient = Twilio::REST::Client.new

  def send_creation_sms_to_owner
    message = "Hi #{user.name}, your new FollowUp task has \
               been sent to #{recipients.decorator_names} \
               regarding: #{subject}.\
               \n\nWe'll keep you updated with their status, Cheers!"
    send_sms(message, user.phone_number)
  end

  def send_creation_sms_to_recipients
    
  end

  private

  def send_sms(message, to_phone_number)
    @@TwilioClient.messages.create(
      from: TWILIO_PHONE_NUMBER,
      to: to_phone_number,
      body: message
    )
  end
end