class Recipient < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :name, :phone_number
  validates :phone_number, uniqueness: true, phony_plausible: { default_country_code: 'US' }

  searchkick word_start: [:name, :phone_number]

  def self.elastic_search(query)
    search(query, fields: [{name: :word_start}, {phone_number: :word_start}])
  end
end
