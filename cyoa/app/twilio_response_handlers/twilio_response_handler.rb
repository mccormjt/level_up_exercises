class TwilioResponseHandler
  include SmsSendable

  def initialize(from_phone_number, body)
    @from_phone_number = from_phone_number
    @body = body
  end

  def respond
    raise 'Twililo Response Handlers Must Implement the "respond" method'
  end

  def phone_number
    @from_phone_number
  end

  def self.description
    raise 'Twililo Response Handlers Must Implement the "description" method'
  end

  def self.call_to_action
    raise 'Twililo Response Handlers Must Implement the "call_to_action" method'
  end
end