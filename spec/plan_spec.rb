require 'spec_helper'

describe 'Plan', :vcr, class: Pin::Plan do
  let(:time) { Time.now.iso8601(4) }
  let(:plan) {
    { name: "Plan#{time}",
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
     interval: 1,
     interval_unit: 'day',
     setup_amount: 27900,
     trial_amount: 0,
     trial_interval: '',
     trial_interval_unit: '' }
  }

  let(:plan_2_token) {
    Pin::Plan.create(plan_2)['token']
  }

  let(:plan_token) {
    Pin::Plan.create(plan)['token']
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

  let(:subscription) {
    { plan_token: plan_token,
      customer_token: customer_token,
      include_setup_fee: false }
  }

  let(:subscription_token) {
    Pin::Subscription.create(subscription)['token']
  }

  let(:subscription_2) {
    { plan_token: plan_2_token,
     customer_token: customer_token,
     include_setup_fee: false }
  }

  let(:subscription_2_token) {
    Pin::Subscription.create(subscription_2)['token']
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a new plan and return its details' do
    expect(Pin::Plan.create(plan))
      .to match a_hash_including("name"=>match(/(Plan)/),
                                 "token"=>match(/(plan)[_]([\w-]{22})/),
                                 "amount"=>1000,
                                 "currency"=>"AUD",
                                 "setup_amount"=>0,
                                 "trial_amount"=>0,
                                 "interval"=>30,
                                 "interval_unit"=>"day",
                                 "trial_interval"=>7,
                                 "trial_interval_unit"=>"day",
                                 "expiration_interval"=>0,
                                 "expiration_interval_unit"=>"",
                                 "active_subscriptions"=>0,
                                 "trial_subscriptions"=>0)
  end

  it 'should return a paginated list of all plans' do
    expect(Pin::Plan.all).to_not eq []
  end

  it 'should go to a specific page when page paramater is passed' do
    request = Pin::Plan.all(2, true)
    expect(request[:pagination]['current']).to eq 2
  end

  it 'should list customers on a page given a page' do
    request = Pin::Plan.all(1, true)
    expect(request[:response]).to_not eq []
  end

  it 'should return pagination if true is passed for pagination' do
    request = Pin::Plan.all(1, true)
    request[:pagination].key?(%W('current previous next per_page pages count))
  end

  it 'should return the details of a specified plan given a token' do
    expect(Pin::Plan.find(plan_token)['token']).to eq(plan_token)
  end

  it 'should update the name of a specified plan given a token' do
    expect(Pin::Plan.update(plan_token, { name: "Updated" })['name'])
      .to eq("Updated")
    Pin::Plan.delete(plan_token) # Cleanup as Plan names must be unique
  end

  it 'should delete a plan with zero subscriptions given a token' do
    expect(Pin::Plan.delete(plan_token).code).to eq 204
  end

  it 'should delete a plan and all de-activated subscriptions' do
    subscription_2_token # attach a subscription to the plan
    Pin::Subscription.delete(subscription_2_token) # deactivate subscription
    expect(Pin::Plan.delete(plan_token).code).to eq 204
  end

  it 'should create a new subscription to the specified plan' do
    plan = { object: Pin::Plan.create_subscription(plan_token, customer_token),
             created_at: Time.now }
    expect(plan[:object])
      .to match a_hash_including("state"=>"trial",
                                 "token"=>match(/(sub)[_]([\w-]{22})/),
                                 "plan_token"=>"#{plan_token}",
                                 "customer_token"=>"#{customer_token}",
                                 "card_token"=> nil)
  end

  it 'should create new plan & linked subscription using a new credit card (billing card_2)' do
    link_card_2_to_customer
    expect(Pin::Plan.create_subscription(plan_2_token, customer_token, card_2_token))
      .to match a_hash_including("state"=>"active",
                                 "token"=>match(/(sub)[_]([\w-]{22})/),
                                 "plan_token"=>"#{plan_2_token}",
                                 "customer_token"=>"#{customer_token}",
                                 "card_token"=>"#{card_2_token}")
    charges = Pin::Customer.charges(customer_token)
    expect(charges[0]['card']['token']).to eq(card_2_token)
  end

  it 'should return a paginated list of subscriptions for a plan' do
    subscription_token # attach a subscription to the plan
    subscription_list = Pin::Plan.subscriptions(plan_token)
    expect(subscription_list[0]['token']).to eq(subscription_token)
  end
end
