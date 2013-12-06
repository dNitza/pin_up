require 'spec_helper'

describe "Errors", :vcr, class: Pin::PinError do
  before(:each) do
    Pin::Base.new(ENV["PIN_SECRET"], :test)
  end

  it "should raise a 404 error when looking for a customer that doesn't exist" do
    expect{Pin::Customer.find('foo')}.to raise_error(Pin::ResourceNotFound, "The requested resource could not be found.")
  end

  it "should raise a 422 error when trying to update missing a param" do
    options = {email: "dNitza@gmail.com", card: {address_line1: "12345 Fake Street", expiry_month: "05", expiry_year: "2014", cvc: "123", name: "Daniel Nitsikopoulos", address_city: "Melbourne", address_postcode: "1234", address_state: "VIC", address_country: "Australia"}}
    expect{Pin::Customer.update('cus_sRtAD2Am-goZoLg1K-HVpA', options)}.to raise_error(Pin::InvalidResource, "card_number_invalid: Card number can't be blank")
  end

  it "should raise a 422 error when trying to make a payment with an expired card" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", card: {
        number: "5520000000000000",
        expiry_month: "05",
        expiry_year: "2012",
        cvc: "123",
        name: "Roland Robot",
        address_line1: "42 Sevenoaks St",
        address_city: "Lathlain",
        address_postcode: "6454",
        address_state: "WA",
        address_country: "Australia",
      }}
    expect{Pin::Charges.create(options)}.to raise_error(Pin::InvalidResource, "card_expiry_month_invalid: Card expiry month is expiredcard_expiry_year_invalid: Card expiry year is expired")
  end

  it "should raise a 400 error when trying to make a payment and a valid card gets declined" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", card: {
        number: "5560000000000001",
        expiry_month: "05",
        expiry_year: "2018",
        cvc: "123",
        name: "Roland Robot",
        address_line1: "42 Sevenoaks St",
        address_city: "Lathlain",
        address_postcode: "6454",
        address_state: "WA",
        address_country: "Australia",
      }}
    expect{Pin::Charges.create(options)}.to raise_error(Pin::ChargeError)
  end

  it "should raise a 422 error when trying to make a payment with an invalid card" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", card: {
        number: "5520000000000099",
        expiry_month: "05",
        expiry_year: "2014",
        cvc: "123",
        name: "Roland Robot",
        address_line1: "42 Sevenoaks St",
        address_city: "Lathlain",
        address_postcode: "6454",
        address_state: "WA",
        address_country: "Australia",
      }}
    expect{Pin::Charges.create(options)}.to raise_error(Pin::InvalidResource, "card_number_invalid: Card number is not a valid Visa or Mastercard number")
  end

  it "Should raise a ResourceNotFound error when can't find customer" do
    expect{Pin::Customer.charges("foo")}.to raise_error(Pin::ResourceNotFound, "The requested resource could not be found.")
  end


  it "should raise a 422 error if no 2nd argument is given" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", customer_token: "cus_8ImkZdEZ6BXUA6NcJDZg_g"   }
    @charge = Pin::Charges.create(options)    
    expect{Pin::Refund.create(@charge['token'])}.to raise_error(Pin::InvalidResource, "invalid_resource: One or more parameters were missing or invalid. Amount: can't be blank")
  end  

  xit "should raise a 422 error if a value of < 100 is given" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", customer_token: "cus_8ImkZdEZ6BXUA6NcJDZg_g"   }
    @charge = Pin::Charges.create(options)    
    expect{Pin::Refund.create(@charge['token'], 90)}.to raise_error(Pin::InvalidResource, "One or more parameters were missing or invalid")
  end  

end