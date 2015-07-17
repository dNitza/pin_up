require 'spec_helper'

describe Pin::Balance, :vcr do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'returns the current balance of your Pin Payments account.' do
    expect(Pin::Balance.get).to include('available', 'pending')
  end
end
