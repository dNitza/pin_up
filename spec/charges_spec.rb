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
    options = { email: 'dNitza@gmail.com', description: 'A new charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: 'cus_6XnfOD5bvQ1qkaf3LqmhfQ' }
    expect(Pin::Charges.create(options)['success']).to eq true
  end

  it 'should show a charge given a token' do
    expect(Pin::Charges.find('ch_YFEgBSs5qTIWggGt72jn7Q')['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'should show a charge given a search term' do
    expect(Pin::Charges.search(query: 'A new charge from testing Pin gem', end_date: 'Mar 25, 2016')).to_not eq []
  end

  it 'should return pagination if "pagination" is true' do
    expect(Pin::Charges.all(3, true)[:pagination]['current']).to eq 3
  end

  it 'should list charges on a page given a page' do
    expect(Pin::Charges.all(1)).to_not eq []
  end

  it 'should create a pre-auth (capture a charge)' do
    options = { email: 'dNitza@gmail.com', description: 'A new captured charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: 'cus_6XnfOD5bvQ1qkaf3LqmhfQ', capture: false }
    expect(Pin::Charges.create(options)['captured']).to eq false
  end

  it 'should capture a charge' do
    options = { email: 'dNitza@gmail.com', description: 'A new captured charge from testing Pin gem', amount: '400', currency: 'AUD', ip_address: '127.0.0.1', customer_token: 'cus_6XnfOD5bvQ1qkaf3LqmhfQ', capture: false }
    token = Pin::Charges.create(options)['token']
    expect(Pin::Charges.capture(token)['success']).to eq true
  end
end
