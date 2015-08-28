require 'rails_helper'

RSpec.describe Recipient, type: :model do
  
  it { should belong_to(:user) }

  it { should have_many(:assignments) }

  it { should have_many(:tasks) }

  it { should validate_presence_of(:user) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:phone_number) }

  it_should_behave_like NameDecorator

  it 'should be able to pluck all names from a relation into a decorator string' do
    create_list(:recipient, 5)
    decorator_names = Recipient.all.decorator_names

    Recipient.all.each do |recipient|
      expect(decorator_names).to include(recipient.name)
    end
  end

  it 'should be able to retrieve all of its upcoming assignments' do
    num_recipient_assignments = 3
    num_other_recipient_assignments = 4
    recipient = create(:recipient)
    create_list(:assignment, num_recipient_assignments, recipient: recipient)
    create_list(:assignment, num_other_recipient_assignments)
    upcoming_assignments = recipient.upcoming_assignments

    expect(upcoming_assignments.size).to eq num_recipient_assignments
    upcoming_assignments.each do |assignment|
      expect(assignment.recipient_id).to eq recipient.id
    end
  end

  context 'user has searchable recipients' do
    before(:each) do
      @user = create(:user)
      @recipient = create(:recipient, user: @user)
      Recipient.reindex
    end

    it 'should be searchable by first name' do
      expect_search_to_yield_users_recipient(@recipient.first_name)
    end

    it 'should be searchable by last name' do
      expect_search_to_yield_users_recipient(@recipient.last_name)
    end

    it 'should be searchable by first letter in name' do
      letter = @recipient.first_name.first
      expect_search_to_yield_users_recipient(letter)
    end

    it 'should be searchable by first letter in last name' do
      letter = @recipient.last_name.first
      expect_search_to_yield_users_recipient(letter)
    end

    it 'should be searchable by phone number' do
      expect_search_to_yield_users_recipient(@recipient.phone_number)
    end

    it 'should be searchable by first digit in number' do
      digit = @recipient.phone_number.gsub('+', '').first
      expect_search_to_yield_users_recipient(digit)
    end

    it 'should scope recipient searches to given user' do
      common_recipient_name = @recipient.name
      other_user = create(:user)
      create(:recipient, user: other_user, name: common_recipient_name)
      Recipient.reindex

      other_user_recipient_search = Recipient.elastic_search(
        common_recipient_name,
        other_user.id
      )
      
      expect(Recipient.all.size).to eq 2
      expect(other_user_recipient_search.size).to eq 1
      expect_search_to_yield_users_recipient(common_recipient_name)
    end

    def expect_search_to_yield_users_recipient(query)
      found_recipient = Recipient.elastic_search(query, @user.id).first
      expect(found_recipient.id).to eq @recipient.id
    end
  end
end
