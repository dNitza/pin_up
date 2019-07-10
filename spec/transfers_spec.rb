require 'spec_helper'

describe Pin::Transfer, :vcr do
  let(:recipient_hash) {
    { email: 'test@example.com',
      name: 'Roland Robot',
      bank_account: { name: 'Roland Robot',
                      bsb: '123456',
                      number: 987654321 } }
  }

  let(:recipient) {
    Pin::Recipient.create(recipient_hash)
  }

  let(:transfer) {
    Pin::Transfer.create({ amount: 400,
                           currency: 'AUD',
                           description: 'Pay day',
                           recipient: recipient['token'] })
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'returns the line items associated with transfer' do
    expect(Pin::Transfer.line_items(transfer['token']).first)
      .to include('amount', 'created_at', 'currency', 'type')
  end

  it 'creates a transfer for a recipient, given a transfer hash' do
    expect(transfer['token']).to match(/^[a-z]{4}[_]/)
  end

  it 'returns a paginated list of all transfers' do
    expect(Pin::Transfer.all).to_not eq []
  end

  it 'returns the details of a transfer' do
    expect(Pin::Transfer.find(transfer['token'])['token']).to eq transfer['token']
  end

  it 'should not show a charge if end_date is out of range' do
    expect(Pin::Transfer.search(end_date: 'Mar 25, 2011')).to eq []
  end

  it 'returns a paginated list of searched transfers' do
    expect(Pin::Transfer.search(query: 'Pay day')).to_not eq []
  end

  it 'should return pagination for search if "pagination" is true' do
    expect(Pin::Transfer.search(3, true, query: 'Pay day')[:pagination]['current']).to eq 3
  end

  it 'should list transfers for search on a page given a page' do
    expect(Pin::Transfer.search(1, query: 'Pay day')).to_not eq []
  end  
end
