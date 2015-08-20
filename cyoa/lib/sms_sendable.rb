module SmsSendable
  def send_sms(message)
    Twilio.send_sms_to(phone_number, message)
  end

  def send_user_sms(message)
    Twilio.send_sms_to(user.phone_number, message)
  end
end
