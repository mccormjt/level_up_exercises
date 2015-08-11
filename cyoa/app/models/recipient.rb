class Recipient < ActiveRecord::Base
  has_many :assignments, inverse_of: :recipient
  has_many :tasks, through: :assignments
  belongs_to :user

  validates_presence_of :user, :name, :phone_number
  validates :phone_number, uniqueness: true, phony_plausible: { default_country_code: 'US' }

  searchkick word_start: [:name, :phone_number]

  def self.elastic_search(query, user_id)
    fields = [{ name: :word_start }, { phone_number: :word_start }]
    where = { user_id: user_id }
    search(query, fields: fields, where: where)
  end
end
