class Recipient < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment
  has_many :assignments, inverse_of: :recipient
  has_many :tasks, through: :assignments

  phony_normalize :phone_number, default_country_code: 'US'

  validates_presence_of :user, :name, :phone_number
  validates :phone_number, uniqueness: true, phony_plausible: { default_country_code: 'US' }

  searchkick word_start: [:name, :phone_number]

  include SmsSendable

  class << self
    def elastic_search(query, user_id)
      fields = [{ name: :word_start }, { phone_number: :word_start }]
      where = { user_id: user_id }
      search(query, fields: fields, where: where)
    end

    def decorator_names
      pluck(:name).join(', ')
    end
  end

  def unarchived_assignments
    query = {'recipients.id' => id, 'tasks.archived' => false}
    Assignment.joins(:task, :recipient).where(query)
  end
end
