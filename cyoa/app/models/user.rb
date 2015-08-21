class User < ActiveRecord::Base
  DEFAULT_COUNTRY_CODE = { default_country_code: 'US' }
  has_many :tasks
  has_many :recipients

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  phony_normalize :phone_number, DEFAULT_COUNTRY_CODE

  validates_presence_of :name, :phone_number, :password
  validates :phone_number, uniqueness: true, phony_plausible: DEFAULT_COUNTRY_CODE

  alias_method :sent_tasks, :tasks

  include SmsSendable

  def self.normalize_phone_number(number)
    PhonyRails.normalize_number(number, DEFAULT_COUNTRY_CODE)
  end

  def self.find_for_authentication(conditions)
    conditions[:phone_number] = normalize_phone_number(conditions[:phone_number])
    super
  end

  def email_required?
    false
  end

  def first_name
    name.split(' ').first
  end

  def recieved_tasks
    recipient.try(:tasks) || []
  end

  def recipient
    Recipient.find_by(phone_number: phone_number)
  end
end
