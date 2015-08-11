class User < ActiveRecord::Base
  has_many :recipients

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone_number, :password
  validates :phone_number, uniqueness: true, phony_plausible: { default_country_code: 'US' }

  def email_required?
    false
  end

  def first_name
    name.split(' ').first
  end
end
