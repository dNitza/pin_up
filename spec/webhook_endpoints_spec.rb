require 'spec_helper'

RSpec.describe 'WebhookEndpoints', :vcr, class: Pin::WebhookEndpoints do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a webhook endpoint and returns its details' do
    options = { url: "http://example.com/webhooks#{Time.now.to_i}/" }
    token = Pin::WebhookEndpoints.create(options)['token']
    expect(token).to match(/^whe_/)
    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should list webhook endpoints' do
    options = { url: "http://example.com/webhooks#{Time.now.to_i}/" }
    token = Pin::WebhookEndpoints.create(options)['token']
    expect(Pin::WebhookEndpoints.all).to_not eq []
    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should list webhook endpoint on a page given a page' do
    request = Pin::WebhookEndpoints.all(1, true)
    options = { url: "http://example.com/webhooks#{Time.now.to_i}/" }
    token = Pin::WebhookEndpoints.create(options)['token']

    expect(request[:response]).to_not eq []

    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should show a webhook endpoint given a token' do
    options = { url: "http://example.com/webhooks#{Time.now.to_i}/" }
    token = Pin::WebhookEndpoints.create(options)['token']

    expect(Pin::WebhookEndpoints.find(token)['token']).to eq token

    Pin::WebhookEndpoints.delete(token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should delete a webhook endpoint given a token' do
    options = { url: "http://example.com/webhooks_delete#{Time.now.to_i}/" }
    token = Pin::WebhookEndpoints.create(options)['token']

    expect(Pin::WebhookEndpoints.delete(token).response.code).to eq "204"
  end
end
