require 'spec_helper'

describe 'Refund', :vcr, class: Pin::Refund do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should list all refunds made to a charge given a token' do
    expect(Pin::Refund.find('ch_5q0DiDnHZIggDfVDqcP-jQ')[0]['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'should return nothing if looking for a charge without a refund' do
    expect(Pin::Refund.find('ch_Dsd62Ey5Hmd3B1dDHNKYvA')).to eq []
  end

  it 'should return a page of refunds given a page and token' do
    expect(Pin::Refund.find('ch_5q0DiDnHZIggDfVDqcP-jQ', 1, true)[:response]).to_not eq []
  end

  it 'should create a refund for a given amount and charge' do
    customer = Pin::Customer.create('email@example.com', number: '5520000000000000', expiry_month: '12', expiry_year: Time.now.year+1, cvc: '123', name: 'Roland Robot', address_line1: '123 fake street', address_city: 'Melbourne', address_postcode: '1234', address_state: 'Vic', address_country: 'Australia')
    options = { email: 'email@example.com', description: 'A new charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: customer['token']}
    @charge = Pin::Charges.create(options)
    expect(Pin::Refund.create(@charge['token'], '400')['amount']).to eq 400
  end

end
