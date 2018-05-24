require 'spec_helper'

RSpec.describe 'WebhookEndpoints', :vcr, class: Pin::WebhookEndpoints do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
    options = { url: "http://example.com/webhooks#{Time.now.to_i}/" }
    @token = Pin::WebhookEndpoints.create(options)['token']
  end

  it 'should create a webhook endpoint and returns its details' do
    expect(@token).to match(/^whe_/)
    Pin::WebhookEndpoints.delete(@token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should list webhook endpoints' do
    expect(Pin::WebhookEndpoints.all).to_not eq []
    Pin::WebhookEndpoints.delete(@token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should list webhook endpoint on a page given a page' do
    request = Pin::WebhookEndpoints.all(1, true)
    expect(request[:response]).to_not eq []
    Pin::WebhookEndpoints.delete(@token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should show a webhook endpoint given a token' do
    expect(Pin::WebhookEndpoints.find(@token)['token']).to eq @token
    Pin::WebhookEndpoints.delete(@token) # since we are only allowed 5 or so sandbox webhooks
  end

  it 'should delete a webhook endpoint given a token' do
    expect(Pin::WebhookEndpoints.delete(@token).response.code).to eq "204"
  end
end
