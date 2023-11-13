require 'spec_helper'
require 'securerandom'

RSpec.describe 'WebhookEndpoints', :vcr, class: Pin::WebhookEndpoints do
  let(:create_endpoint) {
    Pin::WebhookEndpoints.create(url: "http://example.com/webhooks#{SecureRandom.urlsafe_base64}/")
  }

  let(:token) {
    create_endpoint['token']
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a webhook endpoint and returns its details' do
    expect(token).to match(/^whe_/)
    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should list webhook endpoints' do
    create_endpoint
    expect(Pin::WebhookEndpoints.all).to_not eq []
    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should list webhook endpoint on a page given a page' do
    create_endpoint
    request = Pin::WebhookEndpoints.all(1, true)
    expect(request[:response]).to_not eq []
    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should show a webhook endpoint given a token' do
    expect(Pin::WebhookEndpoints.find(token)['token']).to eq token
    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should delete a webhook endpoint given a token' do
    expect(Pin::WebhookEndpoints.delete(token).response.code).to eq "204"
  end
end
