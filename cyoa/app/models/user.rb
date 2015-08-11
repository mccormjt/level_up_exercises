class User < ActiveRecord::Base
  has_many :tasks
  has_many :recipients

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone_number, :password
  validates :phone_number, uniqueness: true, phony_plausible: { default_country_code: 'US' }

  alias_method :sent_tasks, :tasks

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
