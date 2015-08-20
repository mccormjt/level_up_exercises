class StatusResponseHandler < TwilioResponseHandler
  ALPHANUMERIC = /\A\p{Alnum}+\z/
  DEFAULT_DECORATOR_GUID = 3

  def respond
    msg = unrecognized_recipient_msg
    msg ||= unrecognized_task_id_msg
    msg ||= unrecognized_status_id_msg
    msg ||= create_new_status
    send_sms(msg)
  end

  def self.format
     "\"STATUS <taskID> <statusID> - <message>\""
  end

  def self.call_to_action(guid=nil)
    "Reply \"STATUS\" followed by the taskID, one of the following statusIDs, and a message "\
    "to update #{task_assigner(guid)} with your current status"\
    "#{status_options_msg(guid)}"
  end

  def self.status_options_msg(guid=nil)
    "\n\nA = UNSTARTED "\
    "\nB = STARTED "\
    "\nC = BLOCKED "\
    "\nD = COMPLETED"\
    "#{example_msg(guid)}"
  end

  def self.example_msg(guid=DEFAULT_DECORATOR_GUID)
    "\n\nFORMAT:\n#{format}"\
    "\n\nEx: \"STATUS #{guid} C - I am blocked "\
    "until you get me the spreadsheets\""
  end

  private

  def self.task_assigner(guid)
    return 'the task assigner' if guid.nil?
    Assignment.find_by_guid(guid).task.user.name
  end

  def status_state
    args[1] && Status.letter_to_state(args[1])
  end

  def status_msg
    msg = args[2...args.size].join(' ')
    normalize_first_char(msg.strip)
    msg
  end

  def normalize_first_char(str)
    str[0] = '' if (str[0] =~ ALPHANUMERIC).nil?
  end

  def unrecognized_recipient_msg
    "Nobody has assigned any tasks to your phone number" unless recipient
  end

  def unrecognized_task_id_msg
    "You entered an invalid or inactive taskID!"\
    "\n\n#{UpcomingResponseHandler.call_to_action}" unless task
  end

  def unrecognized_status_id_msg
    "Unrecognized statusID! Please choose one of the following:"\
    "#{self.class.status_options_msg}" unless status_state
  end

  def successful_status_update_msg
    "Thanks for your status update! We will let #{task.user.name} know!"
  end

  def create_new_status
    status = Status.new(assignment: assignment, 
                          state: status_state,  message: status_msg)
    if (status.save)
      successful_status_update_msg
    else
      status.errors.full_messages.first << self.class.example_msg(assignment_guid)
    end
  end
end
