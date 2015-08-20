module TwilioSms
  TWILIO_PHONE_NUMBER = Cyoa.config.twilio['phone_number']

  @@TwilioClient = Twilio::REST::Client.new

  def send_sms_to(to_phone_number, message)
    @@TwilioClient.messages.create(
      from: TWILIO_PHONE_NUMBER,
      to: to_phone_number,
      body: message
    )
  end
end
