require 'spec_helper'

RSpec.fdescribe 'Webhooks', :vcr, class: Pin::Webhooks do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should list webhooks' do
    request = Pin::Webhooks.all(1, true)
    expect(request[:response]).to_not eq []
  end

  it 'should show a webhook endpoint given a token' do
    token = Pin::Webhooks.all(1, true)[:response].first['token']
    expect(Pin::Webhooks.find(token)['token']).to eq token
  end

  it 'replays a webhook given a token' do
    token = Pin::Webhooks.all(1, true)[:response].first['token']
    expect(Pin::Webhooks.replay(token)['token']).to eq token
  end

end
