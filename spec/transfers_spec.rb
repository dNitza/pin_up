require 'spec_helper'

describe Pin::Transfer, :vcr do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  options = { email: 'hello@example.com', name: 'Roland Robot', bank_account: { name: 'Roland Robot', bsb: '123456', number: 987654321 } }
  let(:recipient){ Pin::Recipient.create(options) }

  it 'creates a transfer for a recipient, given a transfer hash' do
    transfer = { amount: 400, currency: 'AUD', description: 'Pay day', recipient: recipient['token'] }
    expect(Pin::Transfer.create(transfer)['token']).to match(/^[a-z]{4}[_]/)
  end

  it 'returns a paginated list of all transfers' do
    expect(Pin::Transfer.all).to_not eq []
  end

  it 'returns the details of a transfer' do
    options = { amount: 400, currency: 'AUD', description: 'Pay day', recipient: recipient['token'] }
    transfer_token = Pin::Transfer.create(options)['token']
    expect(Pin::Transfer.find(transfer_token)['token']).to eq transfer_token
  end

  xit 'returns the line items associated with transfer' do
    # disabled until an issue with recipient creation is worked out
    options = { amount: 400, currency: 'AUD', description: 'Pay day', recipient: recipient['token'] }
    transfer_token = Pin::Transfer.create(options)['token']
    expect(Pin::Transfer.line_items(transfer_token).first).to include('type', 'object', 'token', 'amount')
  end
end
