require 'spec_helper'

RSpec.describe 'Base', :vcr, class: Pin::Base do
  before(:each) do
    @test_pin = Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should set key correctly'  do
    @pin = Pin::Base.new('KEY', :live)
    expect(@pin.key).to eq 'KEY'
  end

  it 'should set environment to live if no env set' do
    @pin = Pin::Base.new('KEY', :live)
    expect(@pin.base_uri).to eq 'https://api.pinpayments.com/1/'
  end

  it 'should set environment to test when set' do
    expect(@test_pin.base_uri).to eq 'https://test-api.pinpayments.com/1/'
  end

  it 'should raise an error if anything other than '' :live or :test is passed to a new instance' do
    expect { Pin::Base.new('KEY', :foo) }.to raise_error(RuntimeError, "'env' option must be :live or :test. Leave blank for live payments")
  end

  it 'should succesfully connect to Pin' do
    stub_request(:get, "https://#{@test_pin.key}:''@test-api.pinpayments.com/1/customers")
    expect(Pin::Base.make_request(:get, { url: 'customers' }).code).to eq 200
  end

  it "raises a timeout error if we don't get a response in time" do
    @test_pin = Pin::Base.new(ENV['PIN_SECRET'], :test, 0)
    expect { Pin::Base.make_request(:get, { url: 'customers' }) }.to raise_error.with_message(/Timeout/)
  end
end
