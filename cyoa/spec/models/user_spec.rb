require 'spec_helper'

RSpec.describe User, type: :model do
  it { should have_many(:tasks) }

  it { should have_many(:recipients) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:password) }

  it { should validate_presence_of(:phone_number) }

  it 'should allow correct phone number format' do
    user = build(:user)
    expect(user.valid?).to be true
  end

  it 'should not allow a bad phone number format' do
    user = build(:user, phone_number: '1234')
    expect(user.valid?).to be false
  end

  it 'should prefix phone number with a plus' do
    user = create(:user)
    expect(user.phone_number.first).to eq('+')
  end

  it 'should be able to give me the users first name' do
    first = 'John'
    last = 'Doe'
    name = "#{first} #{last}"
    user = build(:user, name: name)

    expect(user.first_name).to eq first
  end

  it 'should start with no recieved tasks' do
    user = create(:user)
    expect(user.recieved_tasks).to be_empty
  end

  it 'should be able to recieve tasks' do
    user = create(:user)
    recipients = create_list(:recipient, 1, phone_number: user.phone_number)
    create(:task, recipients: recipients)
    expect(user.recieved_tasks.size).to be 1
  end

  it 'can normalize phone numbers' do
    denormalized_number = attributes_for(:user)[:phone_number]
    normalization = User.normalize_phone_number(denormalized_number)
    normalized_number = "+#{denormalized_number}"
    expect(normalization).to eq normalized_number
  end
end
