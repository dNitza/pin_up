require 'spec_helper'

RSpec.describe 'Card', :vcr, class: Pin::Card do
  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)

    @options = { number: '5520000000000000',
                 expiry_month: '12',
                 expiry_year: '2025',
                 cvc: '123',
                 name: 'Roland Robot',
                 address_line1: '123 Fake Street',
                 address_city: 'Melbourne',
                 address_postcode: '1234',
                 address_state: 'Vic',
                 address_country: 'Australia' }
   end

  it 'should create a card and respond with the card detail from pin' do
    expect(Pin::Card.create(@options)['token']).to match(/^[a-z]{4}[_]/)
  end
end
