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

  def recipient
    Recipient.find_by_phone_number(phone_number)
  end

  def self.call_to_action
    raise 'Twililo Response Handlers Must Implement the "call_to_action" method'
  end

  protected

  def args
    @args ||= parse_body_args
  end

  def assignment_guid
    @assignment_guid ||= Integer(args[0]) rescue nil
  end

  def assignment
    @assignment ||= recipient && recipient.assignments.find_by_guid(assignment_guid)
  end

  def task
    @task ||= assignment.try(:task)
  end

  private

  def parse_body_args
    arg_pieces = @body.strip.split(' ')
    arg_pieces.shift
    arg_pieces
  end
end