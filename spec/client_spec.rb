require 'spec_helper'

RSpec.describe 'Client', class: Pin::Client do
  it 'delegates http requests to an inner object' do
    inner = double(make_request: 'RESULT')
    client = Pin::RetryingClient.new(inner)
    expect(client.make_request).to eq('RESULT')
  end

  it 'retries if a request fails' do
    inner = double
    client = Pin::RetryingClient.new(inner)
    times = 2
    allow(inner).to receive(:make_request) do
      raise "Oops" if (times -= 1) > 0
      'RESULT'
    end
    expect(client.make_request).to eq('RESULT')
  end

  it 'gives up after a few tries' do
    inner = double
    client = Pin::RetryingClient.new(inner)
    times = 4
    allow(inner).to receive(:make_request) do
      raise "Ooops!" if (times -= 1) > 0
    end
    expect{client.make_request}.to raise_error('Ooops!')
    expect(inner).to have_received(:make_request).exactly(3).times
  end
end