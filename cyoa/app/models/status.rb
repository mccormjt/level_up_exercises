class Status < ActiveRecord::Base
  UNSTARTED = 'UNSTARTED'
  DEFAULT_TIME_ZONE = 'Central Time (US & Canada)'
  enum state: [ :unstarted, :started, :blocked, :completed ]

  LETTER_TO_STATE_INDEX = 
  {
    a: 0,
    b: 1,
    c: 2,
    d: 3,
  }

  belongs_to :assignment

  validates_presence_of :assignment, :message
  validates_inclusion_of :state, in: states.keys

  after_create :send_new_status_msg_to_task_owner

  class << self
    def letter_to_state(letter)
      normalized_letter = letter.to_sym.downcase
      state_index = LETTER_TO_STATE_INDEX[normalized_letter]
      state_index && states.keys[state_index]
    end

    def apply_decorators(statuses)
      statuses.map do |status|
        status.attributes.merge( 
          state: status.decorator_state,
          created_at: status.decorator_created_at,
        )
      end
    end
  end

  def send_new_status_msg_to_task_owner
    owner = assignment.task.user
    msg = "Hi #{owner.first_name}! Your contact #{assignment.recipient.name} "\
          "just updated their status for task:\n#{assignment.task.details_msg}"\
          "\n\nSTATUS: #{decorator_state}\nMESSAGE: #{message}"

    owner.send_sms(msg)
  end

  def decorator_state
    state.upcase
  end

  def decorator_created_at
    created_at.in_time_zone(DEFAULT_TIME_ZONE).to_s
  end
end
