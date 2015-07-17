require 'spec_helper'

describe Pin::BankAccounts, :vcr do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'creates a bank account token and returns its details' do
    options = { name: 'Roland Robot', bsb: '123456', number: '987654321' }
    expect(Pin::BankAccounts.create(options)['token']).to match(/^[a-z]{2}[_]/)
  end
end
