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

  let(:customer) {
    Pin::Customer.create('email@example.com', card_1)
  }

  let(:customer_token) {
    customer['token']
  }

  let(:subscription) {
    { plan_token: plan_token,
      customer_token: customer_token,
      include_setup_fee: false }
  }

  let(:subscription_token) {
    Pin::Subscription.create(subscription)['token']
  }
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a new plan and return its details' do
    expect(Pin::Plan.create(plan))
      .to match a_hash_including("name"=>"Plan#{time}",
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
    expect(Pin::Plan.update(plan_token, { name: "Updated#{plan[:name]}" })['name'])
      .to eq("Updated#{plan[:name]}")
  end

  it 'should delete a plan with zero subscriptions given a token' do
    expect(Pin::Plan.delete(plan_token).code).to eq 204
  end

  it 'should delete a plan and all de-activated subscriptions' do
    subscription_token # attach a subscription to the plan
    Pin::Subscription.delete(subscription_token) #deactivate subscription
    expect(Pin::Plan.delete(plan_token).code).to eq 204 
  end

  it 'should create a new subscription to the specified plan' do
  end

  it 'should return a paginated list of subscriptions for a plan' do
    subscription_token # attach a subscription to the plan
    subscription_list = Pin::Plan.subscriptions(plan_token)
    expect(subscription_list[0]['token']).to eq(subscription_token)
  end
end
