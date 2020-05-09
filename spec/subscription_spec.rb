require 'spec_helper'

describe 'Subscription', :vcr, class: Pin::Subscription do
  let(:time) { Time.now.iso8601(4) }
  let(:plan_1) {
    { name: "Subscription#{time}",
      amount: '1000',
      currency: 'AUD',
      interval: 30,
      interval_unit: 'day',
      setup_amount: 0,
      trial_amount: 0,
      trial_interval: 7,
      trial_interval_unit: 'day' }
  }

  let(:plan_2) {
    { name: "Subscription#{time}",
     amount: '1000',
     currency: 'AUD',
     interval: 30,
     interval_unit: 'day',
     setup_amount: 27900,
     trial_amount: 0 }
  }

  let(:plan_1_token) {
    Pin::Plan.create(plan_1)['token']
  }

  let(:plan_2_token) {
    Pin::Plan.create(plan_2)['token']
  }

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

  let(:card_2) {
    { number: '4200000000000000',
     expiry_month: '12',
     expiry_year: '2020',
     cvc: '111',
     name: 'Roland TestRobot',
     address_line1: '123 Fake Road',
     address_line2: '',
     address_city: 'Melbourne',
     address_postcode: '1223',
     address_state: 'Vic',
     address_country: 'AU' }
  }

  let(:customer) {
    Pin::Customer.create('email@example.com', card_1)
  }

  let(:customer_token) {
    customer['token']
  }

  let(:card_2_token) {
    Pin::Card.create(card_2)['token']
  }

  let(:link_card_2_to_customer) {
    Pin::Customer.create_card(customer_token, card_2_token)
  }

  let(:subscription_1) {
    { plan_token: plan_1_token,
      customer_token: customer_token,
      include_setup_fee: false }
  }

  let(:subscription_2) {
    link_card_2_to_customer
    { plan_token: plan_2_token,
      customer_token: customer_token,
      card_token: card_2_token,
      include_setup_fee: true }
  }

  let(:subscription_1_token) {
    Pin::Subscription.create(subscription_1)['token']
  }

  let(:subscription_2_token) {
    Pin::Subscription.create(subscription_2)['token']
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a new subscription billing default card and return its details' do
    expect(Pin::Subscription.create(subscription_1))
      .to match a_hash_including("state"=>"trial",
                                 "cancelled_at"=>nil,
                                 "token"=>match(/(sub)[_]([\w-]{22})/),
                                 "plan_token"=>"#{plan_1_token}",
                                 "customer_token"=>"#{customer_token}",
                                 "card_token"=> nil)
  end

  it 'should create a new subscription billing card_2' do
    expect(Pin::Subscription.create(subscription_2))
      .to match a_hash_including("state"=>"active",
                                 "token"=>match(/(sub)[_]([\w-]{22})/),
                                 "plan_token"=>"#{plan_2_token}",
                                 "customer_token"=>"#{customer_token}",
                                 "card_token"=>"#{card_2_token}")
    charges = Pin::Customer.charges(customer_token)
    expect(charges[0]['card']['token']).to eq(card_2_token)
  end

  it 'should create a new subscription with setup fee, charge equals amount + setup fee' do
    Pin::Subscription.create(subscription_2)
    charges = Pin::Customer.charges(customer_token)
    expect(charges[0]['amount'].to_i).to eq (plan_2[:setup_amount].to_i + plan_2[:amount].to_i)
  end

  it 'should list all subscriptions' do
    expect(Pin::Subscription.all).to_not eq []
  end

  it 'should go to a specific page when page paramater is passed' do
    request = Pin::Subscription.all(20, true)
    expect(request[:pagination]['current']).to eq 20
  end

  it 'should list subscriptions on a page given a page' do
    request = Pin::Subscription.all(1, true)
    expect(request[:response]).to_not eq []
  end

  it 'should return pagination if true is passed for pagination' do
    request = Pin::Subscription.all(1, true)
    request[:pagination].keys.include?(%W('current previous next per_page pages count))
  end

  it 'should not list subscriptions for a given page if there are no subscriptions' do
    request = Pin::Subscription.all(250, true)
    expect(request[:response]).to eq []
  end

  it 'should show a subscription given a token' do
    expect(Pin::Subscription.find(subscription_2_token)['token']).to eq(subscription_2_token)
  end

  it 'should update the subscription charged card given a subscription & card token' do
    Pin::Customer.create_card(customer_token, card_2_token) # register card to customer
    sub = Pin::Subscription.update(subscription_1_token, card_2_token)
    expect(sub['card_token']).to eq card_2_token
    primary_customer_card_token = customer['card']['token']
    expect(primary_customer_card_token).to_not eq card_2_token
  end

  it 'should delete(deactivate) a subscription given a token' do
    expect(Pin::Subscription.delete(subscription_2_token)['state']).to eq('cancelling')
  end

  it 'should reactivate the subscription given a token' do
    deactivated = Pin::Subscription.delete(subscription_2_token)
    expect(Pin::Subscription.reactivate(deactivated['token'])['state']).to eq('active')
  end

  ## History no longer exists as an endpoint
  ## Leaving this in for reference

  # it 'should fetch history for a subscription given a token' do
  #   expect(Pin::Subscription.history(subscription_2_token)).to_not eq []
  # end

  # it 'should go to a specific page when page parameter is passed' do
  #   request = Pin::Subscription.history(subscription_2_token, 20, true)
  #   expect(request[:pagination]['current']).to eq 20
  # end

  # it 'should list subscriptions on a page given a page' do
  #   request = Pin::Subscription.history(subscription_2_token, 1, true)
  #   expect(request[:response]).to_not eq []
  # end

  # it 'should return pagination if true is passed for pagination' do
  #   request = Pin::Subscription.history(subscription_2_token, 1, true)
  #   request[:pagination].key?(%W('current previous next per_page pages count))
  # end

  # it 'should not list subscriptions for a given page if there are no subscriptions' do
  #   request = Pin::Subscription.history(subscription_2_token, 25, true)
  #   expect(request[:response]).to eq []
  # end
end
