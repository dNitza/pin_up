require 'spec_helper'

RSpec.describe 'Card', :vcr, class: Pin::Card do
  let(:card_1) {
    { number: '5520000000000000',
      expiry_month: '12',
      expiry_year: Date.today.next_year.year.to_s,
      cvc: '123',
      name: 'Roland Robot',
      address_line1: '123 Fake Street',
      address_city: 'Melbourne',
      address_postcode: '1234',
      address_state: 'Vic',
      address_country: 'Australia' }
  }

  before(:each) do
    Pin::Base.new(ENV['PIN_SECRET'], :test)
  end

  it 'should create a card and respond with the card detail from pin' do
    expect(Pin::Card.create(card_1)['token']).to match(/^[a-z]{4}[_]/)
  end
end
