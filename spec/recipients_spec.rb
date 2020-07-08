require 'spec_helper'

describe Pin::Recipient, :vcr do
  let(:recipient_details) {
    { email: 'hello@example.com',
      name: 'Roland Robot',
      bank_account: {
        name: 'Roland Robot',
        bsb: '012984',
        number: 987654321
      } }
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a new recipient' do
    expect(Pin::Recipient.create(recipient_details)['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'lists out recipients' do
    expect(Pin::Recipient.all).to_not eq []
  end

  it 'gets a recipient given a token' do
    recipient = Pin::Recipient.create(recipient_details)
    expect(Pin::Recipient.find(recipient['token'])['token']).to eq recipient['token']
  end

  it 'updates the given details of a recipient and returns its details' do
    recipient = Pin::Recipient.create(recipient_details)
    updated_options = { email: 'new_email@example.com' }
    expect(Pin::Recipient.update(recipient['token'], updated_options)['email']).to eq 'new_email@example.com'
  end

  it 'returns a list of recipients transfers' do
    recipient = Pin::Recipient.create(recipient_details)
    transfer = { amount: 400, currency: 'AUD', description: 'Pay day', recipient: recipient['token'] }
    Pin::Transfer.create(transfer)

    expect(Pin::Recipient.transfers(recipient['token'])).to_not eq []
  end
end
