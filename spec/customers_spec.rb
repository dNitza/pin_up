require 'spec_helper'

describe 'Customer', :vcr, class: Pin::Customer do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)

    @options = { number: '5520000000000000',
                 expiry_month: '12',
                 expiry_year: '2025',
                 cvc: '123',
                 name: 'Roland Robot',
                 address_line1: '123 Fake Street',
                 address_city: 'Melbourne',
                 address_postcode: '1234',
                 address_state: 'Vic',
                 address_country: 'Australia' }

    @customer_token = Pin::Customer.create('email@example.com', @options)['token']

    @charges = Pin::Charges.create(email: 'email@example.com',
                                   description: 'Charge description',
                                   amount: '500',
                                   currency: 'AUD',
                                   number: '5520000000000000',
                                   ip_address: '203.192.1.172',
                                   customer_token: @customer_token)
  end

  it 'should list customers' do
    expect(Pin::Customer.all).to_not eq []
  end

  it 'should go to a specific page when page paramater is passed' do
    request = Pin::Customer.all(20, true)
    expect(request[:pagination]['current']).to eq 20
  end

  it 'should list customers on a page given a page' do
    request = Pin::Customer.all(1, true)
    expect(request[:response]).to_not eq []
  end

  it 'should return pagination if true is passed for pagination' do
    request = Pin::Customer.all(1, true)
    request[:pagination].keys.include?(%W('current previous next per_page pages count))
  end

  it 'should not list customers on a page given a page if there are no customers' do
    request = Pin::Customer.all(25, true)
    expect(request[:response]).to eq []
  end

  it 'should show a customer given a token' do
    expect(Pin::Customer.find(@customer_token)['token']).to eq(@customer_token)
  end

  it 'should list charges to a customer given a token' do
    Pin::Customer.charges(@customer_token)
    expect(Pin::Customer.charges(@customer_token)[0]['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'should show pagination on a page given a token and a page' do
    expect(Pin::Customer.charges(@customer_token, 5, true)[:pagination]['current']).to eq 5
  end

  it 'should list charges to a customer on a page given a token and a page' do
    expect(Pin::Customer.charges(@customer_token, 1, true)[:response][0]['token']).to match(/^[a-z]{2}[_]/)
  end

  it 'should create a customer given an email and card details' do
    expect(Pin::Customer.create('email@example.com', @options)['token']).to match(/^[a-z]{3}[_]/)
  end

  it 'should update a customer given a token and details to update' do
    expect(Pin::Customer.update(@customer_token, @options)['card']['address_line1']).to eq '123 Fake Street'
  end

  it 'should create a customer given a card token customer email' do
    @card = Pin::Card.create(@options)
    expect(Pin::Customer.create('nitza98@hotmail.com', @card['token'])['token']).to match(/^[a-z]{3}[_]/)
  end

  it 'should list all cards belonging to this customer' do
    expect(Pin::Customer.cards(@customer_token).first['token']).to match(/(card)[_]([\w-]{22})/)
  end

  it 'should create a card given customer token and card hash' do
    card = { publishable_api_key: ENV['PUBLISHABLE_SECRET'], number: '5520000000000000', expiry_month: '12', expiry_year: '2018', cvc: '123', name: 'Roland TestRobot', address_line1: '123 Fake Road', address_line2: '', address_city: 'Melbourne', address_postcode: '1223', address_state: 'Vic', address_country: 'AU' }
    expect(Pin::Customer.create_card(@customer_token, card)['token']).to match(/(card)[_]([\w-]{22})/)
  end

  it 'should create a card then add it to a customer' do
    card_token = Pin::Card.create(@options)['token']
    expect(Pin::Customer.create_card(@customer_token, card_token)['token']).to match(/(card)[_]([\w-]{22})/)
  end

  # it 'should delete a card given a token', record: :all do
  #   card_token = Pin::Card.create(@options)['token']
  #   Pin::Customer.create_card(@customer_token, @options)
  #   expect(Pin::Customer.delete_card(@customer_token, card_token).code).to eq 204
  # end
end
