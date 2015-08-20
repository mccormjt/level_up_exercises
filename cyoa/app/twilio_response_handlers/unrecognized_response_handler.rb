class UnrecognizedResponseHandler < TwilioResponseHandler
  def respond
    send_sms(self.class.call_to_action)
  end

  def self.call_to_action
    "Sorry, your last message wasn't recognized!"\
    "\n#{OptionsResponseHandler.call_to_action}"
  end
end