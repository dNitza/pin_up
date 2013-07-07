require 'spec_helper'

describe "Errors", :vcr, class: Pin::PinError do
  before(:each) do
    Pin::Base.new(ENV["PIN_SECRET"], :test)
  end

  it "should raise a 404 error when looking for a customer that doesn't exist" do
    expect{Pin::Customer.find('foo')}.to raise_error(Pin::PinError, 'The requested resource could not be found.')
  end

end