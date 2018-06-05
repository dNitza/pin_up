require 'spec_helper'

describe 'Errors', :vcr, class: Pin::PinError do
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

  let(:charge_hash) {
    { email: 'email@example.com',
      description: 'A new charge from testing Pin gem',
      amount: '400',
      currency: 'AUD',
      ip_address: '127.0.0.1',
      card: {
        number: '5520000000000000',
        expiry_month: '05',
        expiry_year: '2012',
        cvc: '123',
        name: 'Roland Robot',
        address_line1: '42 Sevenoaks St',
        address_city: 'Lathlain',
        address_postcode: '6454',
        address_state: 'WA',
        address_country: 'Australia'
      } }
  }

  let(:hash_of_details) {
    { email: 'email@example.com',
      description: 'A new charge from testing Pin gem',
      amount: '400',
      currency: 'AUD',
      ip_address: '127.0.0.1',
      card: {
        number: '5560000000000001',
        expiry_month: '12',
        expiry_year: '2025',
        cvc: '123',
        name: 'Roland Robot',
        address_line1: '42 Sevenoaks St',
        address_city: 'Lathlain',
        address_postcode: '6454',
        address_state: 'WA',
        address_country: 'Australia'
      } }
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

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  ###
  # Customer Errors
  ###
  it 'should raise a 400 error when attempting to delete customer\'s primary card' do
    cards = Pin::Customer.cards(customer_token)
    primary_card_token = cards.select{|card| card['primary'] }.first['token']
    expect { Pin::Customer.delete_card(customer_token, primary_card_token) }.to raise_error do |error|
      expect(error).to be_a Pin::InvalidResource
      expect(error.message).to eq 'You cannot delete a customer\'s primary card token'
      expect(error.response).to be_a Hash
    end
  end

  it 'should raise a 404 error when looking for a customer that doesn\'t exist' do
    expect { Pin::Customer.find('foo') }.to raise_error do |error|
      expect(error).to be_a Pin::ResourceNotFound
      expect(error.message).to eq 'The requested resource could not be found.'
      expect(error.response).to be_a Hash
    end
  end

  it 'should raise an Unauthorized error when token is invalid' do
    Pin::Base.new('arbitrary_token', :test)
    expect { Pin::Customer.charges('foo') }.to raise_error do |error|
      expect(error).to be_a Pin::Unauthorized
      expect(error.message).to eq 'Not authorised. (Check API Key)'
      expect(error.response).to be_a Hash
    end
  end

  it 'Should raise a ResourceNotFound error when can\'t find customer' do
    expect { Pin::Customer.charges('foo') }.to raise_error do |error|
      expect(error).to be_a Pin::ResourceNotFound
      expect(error.message).to eq 'The requested resource could not be found.'
      expect(error.response).to be_a Hash
    end
  end

  it 'should raise a 422 error when trying to update missing a param' do
    hash_w_no_credit_card_or_name = hash_of_details.tap do |h|
      h[:card][:number] = ''
      h[:card][:name] = ''
    end
    expect { Pin::Customer.update(customer_token, hash_w_no_credit_card_or_name) }.to raise_error do |error|
      expect(error).to be_a Pin::InvalidResource
      expect(error.response['messages']).to be_a Array
      expect(error.response['messages'][0]).to match a_hash_including("message"=>"Card number can't be blank")
      expect(error.response['messages'][1]).to match a_hash_including("message"=>"Card name can't be blank")
    end
  end

  ###
  # Charge Errors
  ###
  it 'should raise a 422 error when trying to make a payment with an expired card' do
    hash_w_expired_credit_card = hash_of_details.tap do |h|
      h[:card][:expiry_year] = '2001'
    end
    expect { Pin::Charges.create(hash_w_expired_credit_card) }.to raise_error do |error|
      expect(error).to be_a Pin::InvalidResource
      expect(error.response['messages']).to be_a Array
      expect(error.response['messages'][0]).to match a_hash_including("message"=>"Card expiry month is expired")
      expect(error.response['messages'][1]).to match a_hash_including("message"=>"Card expiry year is expired")
    end
  end

  it 'should raise a 400 error when trying to make a payment and a valid card gets declined' do
    hash_w_card_declined = hash_of_details.tap do |h|
      h[:card][:number] = '5560000000000001'
    end
    expect { Pin::Charges.create(hash_w_card_declined) }.to raise_error(Pin::ChargeError)
  end

  it 'should raise a 422 error when trying to make a payment with an invalid card' do
    hash_w_invalid_card = hash_of_details.tap do |h|
      h[:card][:number] = '5520000000000099'
    end
    expect { Pin::Charges.create(hash_w_invalid_card) }.to raise_error do |error|
      expect(error).to be_a Pin::InvalidResource
      expect(error.response['messages'][0]).to match a_hash_including("message"=>"Card number is not valid")
    end
  end

  ###
  # Refund Errors
  ###
  it 'should raise a 422 error if no 2nd argument is given' do
    expect { Pin::Refund.create(charge['token']) }.to raise_error do |error|
      expect(error).to be_a Pin::InvalidResource
      expect(error.message).to eq "amount_invalid: Amount can't be blank amount_invalid: Amount is not a number "
      expect(error.response).to be_a Hash
    end
  end

  end

  end
end
