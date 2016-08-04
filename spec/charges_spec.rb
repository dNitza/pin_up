require 'spec_helper'

describe 'Charge', :vcr, class: Pin::Charges do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should list charges in Pin' do
    expect(Pin::Charges.all).to_not eq []
  end

  it 'should not show a charge if end_date is out of range' do
    expect(Pin::Charges.search(end_date: 'Mar 25, 2011')).to eq []
  end

  it 'should create a charge given details' do
    customer = Pin::Customer.create('email@example.com', number: '5520000000000000', expiry_month: '12', expiry_year: Time.now.year+1, cvc: '123', name: 'Roland Robot', address_line1: '123 fake street', address_city: 'Melbourne', address_postcode: '1234', address_state: 'Vic', address_country: 'Australia')
    options = { email: 'email@example.com', description: 'A new charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: customer['token'] }
    expect(Pin::Charges.create(options)['success']).to eq true
  end

  it 'should show a charge given a token' do
    expect(Pin::Charges.find('ch_YFEgBSs5qTIWggGt72jn7Q')['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'should show a charge given a search term' do
    expect(Pin::Charges.search(query: 'A new charge from testing Pin gem', end_date: 'Aug 31, 2016')).to_not eq []
  end

  it 'should return pagination if "pagination" is true' do
    expect(Pin::Charges.all(3, true)[:pagination]['current']).to eq 3
  end

  it 'should list charges on a page given a page' do
    expect(Pin::Charges.all(1)).to_not eq []
  end

  it 'should return pagination for search if "pagination" is true' do
    expect(Pin::Charges.search(3, true, query: 'A new charge from testing Pin gem', end_date: 'Aug 31, 2016')[:pagination]['current']).to eq 3
  end

  it 'should list charges for search on a page given a page' do
    expect(Pin::Charges.search(1, query: 'A new charge from testing Pin gem', end_date: 'Aug 31, 2016')).to_not eq []
  end

  it 'should create a pre-auth (capture a charge)' do
    customer = Pin::Customer.create('email@example.com', number: '5520000000000000', expiry_month: '12', expiry_year: Time.now.year+1, cvc: '123', name: 'Roland Robot', address_line1: '123 fake street', address_city: 'Melbourne', address_postcode: '1234', address_state: 'Vic', address_country: 'Australia')
    options = { email: 'email@example.com', description: 'A new captured charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: customer['token'], capture: false }
    expect(Pin::Charges.create(options)['captured']).to eq false
  end

  it 'should capture a charge' do
    customer = Pin::Customer.create('email@example.com', number: '5520000000000000', expiry_month: '12', expiry_year: Time.now.year+1, cvc: '123', name: 'Roland Robot', address_line1: '123 fake street', address_city: 'Melbourne', address_postcode: '1234', address_state: 'Vic', address_country: 'Australia')
    options = { email: 'email@example.com', description: 'A new captured charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: customer['token'], capture: false }
    token = Pin::Charges.create(options)['token']
    expect(Pin::Charges.capture(token)['success']).to eq true
  end
end
