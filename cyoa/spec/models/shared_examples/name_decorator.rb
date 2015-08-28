require 'rails_helper'

shared_examples NameDecorator do
  before(:each) do
    @first = 'John'
    @last  = 'Doe'
    @name  = "#{@first} #{@last}"
    @user  = build(:user, name: @name)
  end

  it 'should be able to give me the users first name' do
    expect(@user.first_name).to eq @first
  end

  it 'should be able to give me the users last name' do
    expect(@user.last_name).to eq @last
  end
end
