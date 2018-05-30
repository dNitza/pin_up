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
  end

  it 'should return the details of a specified plan' do
  end

  it 'should update the name of a specified plan' do
  end

  it 'should delete a plan and all of its subscriptions' do
  end

  it 'should create a new subscription to the specified plan' do
  end

  it 'should return a paginated list of subscriptions for a plan' do
  end
end
