class UpcomingResponseHandler < TwilioResponseHandler
  def respond
    # TODO
  end

  def self.description
    "UPCOMING - lists the next few upcoming tasks that are due, "\
    "along with their respective Task IDs that can be used with "\
    "other commands such as SHOW <taskID>"
  end
end
