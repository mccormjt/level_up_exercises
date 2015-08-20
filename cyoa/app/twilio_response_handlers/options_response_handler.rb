class OptionsResponseHandler < TwilioResponseHandler
  OPTIONS_MSG = "Here are some commands you can respond with:"\
                "\n\n#{UpcomingResponseHandler.call_to_action}"\
                "\n\n#{ShowResponseHandler.call_to_action}"\
                "\n\n#{StatusResponseHandler.call_to_action}"

  def respond
    send_sms(OPTIONS_MSG)
  end

  def self.call_to_action
    "Reply \"OPTIONS\" to see a list of "\
    "available commands you can respond with"
  end
end
