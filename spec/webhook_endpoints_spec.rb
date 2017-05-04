require 'spec_helper'

RSpec.describe 'WebhookEndpoints', :vcr, class: Pin::WebhookEndpoints do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a webhook endpoint and returns its details' do
    options = { url: "http://example.com/webhooks/" }
    expect(Pin::WebhookEndpoints.create(options)['token']).to match(/^whe_/)
  end

  it 'should list webhook endpoints' do
    expect(Pin::WebhookEndpoints.all).to_not eq []
  end

  it 'should list webhook endpoint on a page given a page' do
    request = Pin::WebhookEndpoints.all(1, true)
    expect(request[:response]).to_not eq []
  end

  it 'should show a webhook endpoint given a token' do
    expect(Pin::WebhookEndpoints.find('whe__ld78HRWava8Wx2wQMxyew')['token']).to eq 'whe__ld78HRWava8Wx2wQMxyew'
  end

  it 'should delete a webhook endpoint given a token' do
    options = { url: "http://example.com/webhooks_delete/" }
    token = Pin::WebhookEndpoints.create(options)['token']

    expect(Pin::WebhookEndpoints.delete(token).response.code).to eq "204"
  end
end
