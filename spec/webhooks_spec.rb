require 'spec_helper'

RSpec.describe 'Webhooks', :vcr, class: Pin::Webhooks do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should list webhooks' do
    request = Pin::Webhooks.all(1, true)
    expect(request[:response]).to_not eq []
  end

  it 'should show a webhook given a token' do
    token = Pin::Webhooks.all(1, true)[:response].first['token']
    expect(Pin::Webhooks.find(token)['token']).to eq token
  end

  xit 'replays a webhook given a token' do
    token = Pin::Webhooks.all(1, true)[:response].last['token']
    expect(Pin::Webhooks.replay(token)['token']).to eq token
  end

end
