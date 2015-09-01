require 'rails_helper'

RSpec.describe Status, type: :model do
  let(:status) { create(:status) }

  it { should belong_to(:assignment) }

  it { should validate_presence_of(:assignment) }

  it { should validate_presence_of(:message) }

  it 'should match up its letter states to enum states' do
    expect(Status::LETTER_TO_STATE_INDEX.size).to eq Status.states.size
  end

  it 'should have letter states that do not skip increments' do
    last_key = nil
    last_value = nil
    Status.states.each do |key, value|
      next unless last_key && last_value
      expect(last_key.next).to eq(key)
      expect(last_value.next).to eq(value)
      last_key = key
      last_value = value
    end
  end

  it 'should be able to convert a lowercase letter to its corresponding state' do
    expect_letter_to_convert_to_state('a', 0)
  end

  it 'should be able to convert an uppercase letter to its corresponding state' do
    expect_letter_to_convert_to_state('B', 1)
  end

  it 'should be able to convert an uppercase symbol to its corresponding state' do
    expect_letter_to_convert_to_state(:C, 2)
  end

  it 'should be able to decorate status states to uppercase' do
    expect(status.decorator_state).to eq status.state.upcase
  end

  it 'should be able to decorate its created at to default timezone' do
    expected_created_at = status.created_at.in_time_zone(Status::DEFAULT_TIME_ZONE).to_s
    expect(status.decorator_created_at).to eq expected_created_at
  end

  it 'should be able to apply its class decorators to statuses relation' do
    statuses = create_list(:status, 3)
    decorated_statuses = Status.apply_decorators(Status.all)
    first_status = statuses.first
    first_decorated_status = decorated_statuses.first

    expect(first_decorated_status[:created_at]).to eq first_status.decorator_created_at
    expect(first_decorated_status[:state]).to eq first_status.decorator_state
  end


  def expect_letter_to_convert_to_state(letter, state_index)
    converted_state = Status.letter_to_state(letter)
    actual_state = Status.states.keys[state_index]
    expect(converted_state).to eq actual_state
  end
end
