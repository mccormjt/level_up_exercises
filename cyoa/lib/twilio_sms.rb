module TwilioSms
  TWILIO_PHONE_NUMBER = Cyoa.config.twilio['phone_number']

  class << self
    def async_send_sms_to(to_phone_number, message)
      SendSmsWorker.perform_async(to_phone_number, message)
    end

    def send_sms_to(to_phone_number, message)
      Twilio::REST::Client.new.messages.create(
        from: TWILIO_PHONE_NUMBER,
        to: to_phone_number,
        body: message
      )
    end
  end
end
