require 'spec_helper'

describe 'Refund', :vcr, class: Pin::Refund do
  let(:card_1) {
    { number: '5520000000000000',
     expiry_month: '12',
     expiry_year: '2025',
     cvc: '123',
     name: 'Roland Robot',
     address_line1: '123 Fake Street',
     address_city: 'Melbourne',
     address_postcode: '1234',
     address_state: 'Vic',
     address_country: 'Australia' }
  }

  let(:customer_token) {
    Pin::Customer.create('email@example.com', card_1)['token']
  }

  let(:charge) {
    Pin::Charges.create(email: 'email@example.com',
                        description: 'Charge description',
                        amount: '500',
                        currency: 'AUD',
                        number: '5520000000000000',
                        ip_address: '203.192.1.172',
                        customer_token: customer_token)
  }

  let(:no_refund_charge) {
    Pin::Charges.create(email: 'email@example.com',
                        description: 'Charge description',
                        amount: '500',
                        currency: 'AUD',
                        number: '5520000000000000',
                        ip_address: '203.192.1.172',
                        customer_token: customer_token)
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
    Pin::Refund.create(charge['token'], '400')
  end

  it 'should list all refunds made to a charge given a token' do
    expect(Pin::Refund.find(charge['token'])[0]['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'should return nothing if looking for a charge without a refund' do
    expect(Pin::Refund.find(no_refund_charge['token'])).to eq []
  end

  it 'should return a page of refunds given a page and token' do
    expect(Pin::Refund.find(charge['token'], 1, true)[:response]).to_not eq []
  end

  it 'should create a refund for a given amount and charge' do
    expect(Pin::Refund.find(charge['token'])[0]['amount']).to eq 400
  end
end
