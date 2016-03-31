require 'spec_helper'

RSpec.describe 'Client', class: Pin::Client do
  it 'fails if invalid http verb is used' do
    client = Pin::Client.new(:foo, {}, '', '')
    expect {client.make_request}.to raise_error(Pin::ClientError, 'request :method must be one of get, post, put, patch or delete')
  end
end
