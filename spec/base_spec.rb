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
    expect(@pin.base_uri).to eq 'https://api.pin.net.au/1/'
  end

  it 'should set environment to test when set' do
    expect(@test_pin.base_uri).to eq 'https://test-api.pin.net.au/1/'
  end

  it 'should raise an error if anything other than '' :live or :test is passed to a new instance' do
    expect { Pin::Base.new('KEY', :foo) }.to raise_error(RuntimeError, "'env' option must be :live or :test. Leave blank for live payments")
  end

  it 'should list succesfully connect to Pin' do
    stub_request(:get, "https://#{@test_pin.key}:''@test-api.pin.net.au/1/customers")
    expect(Pin::Base.make_request(:get, { url: 'customers' }).code).to eq 200
    # expect(Pin::Base.auth_get('customers').code).to eq 200
  end

  it 'delegates http requests to an inner object' do
    inner = double(make_request: 'RESULT')
    client = RetryingClient.new(inner)
    expect(client.make_request).to eq('RESULT')
  end

  it 'retries if a request fails' do
    inner = double
    client = RetryingClient.new(inner)
    times = 2
    allow(inner).to receive(:make_request) do
      raise "Oops" if (times -= 1) > 0
      'RESULT'
    end
    expect(client.make_request).to eq('RESULT')
  end

  it 'gives up after a few tries' do
    inner = double
    client = RetryingClient.new(inner)
    times = 4
    allow(inner).to receive(:make_request) do
      raise "Ooops!" if (times -= 1) > 0
    end
    expect{client.make_request}.to raise_error('Ooops!')
    expect(inner).to have_received(:make_request).exactly(3).times
  end
end
