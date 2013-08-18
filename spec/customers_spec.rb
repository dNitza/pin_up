require 'spec_helper'

describe "Customer", :vcr, class: Pin::Customer do
  before(:each) do
    Pin::Base.new(ENV["PIN_SECRET"], :test)
  end

  it "should list customers" do
    Pin::Customer.all.should_not == []
  end

  it "should go to a specific page when page paramater is passed" do
    request = Pin::Customer.all(20,true)
    request[:pagination]["current"].should == 20
  end

  it "should list customers on a page given a page" do
    request = Pin::Customer.all(1,true)
    request[:response].should_not == []
  end

  it "should return pagination if true is passed for pagination" do
    request = Pin::Customer.all(1,true)
    request[:pagination].keys.include?(["current", "previous", "next", "per_page", "pages", "count"])
  end

  it "should not list customers on a page given a page if there are no customers" do
    request = Pin::Customer.all(25,true)
    request[:response].should == []
  end

  it "should show a  customer given a token" do
    Pin::Customer.find('cus_8ImkZdEZ6BXUA6NcJDZg_g')['token'].should == "cus_8ImkZdEZ6BXUA6NcJDZg_g"
  end

  it "should list charges to a customer given a token" do
    Pin::Customer.charges('cus_8ImkZdEZ6BXUA6NcJDZg_g')[0]['token'].should match(/^[a-z]{2}[_]/)
  end

  it "should create a customer given an email and card details" do
    Pin::Customer.create('dNitza@gmail.com', {number: '5520000000000000', expiry_month: "12", expiry_year: "2014", cvc: "123", name: 'Roland Robot', address_line1: '123 fake street', address_city: 'Melbourne', address_postcode: '1234', address_state: 'Vic', address_country: 'Australia'})["token"].should match(/^[a-z]{3}[_]/)
  end

  it "should update a customer given a token and details to update" do
    options = {email: "dNitza@gmail.com", card: {number: "5520000000000000", address_line1: "12345 Fake Street", expiry_month: "05", expiry_year: "2014", cvc: "123", name: "Daniel Nitsikopoulos", address_city: "Melbourne", address_postcode: "1234", address_state: "VIC", address_country: "Australia"}}
    Pin::Customer.update('cus_sRtAD2Am-goZoLg1K-HVpA', options)['card']['address_line1'].should == "12345 Fake Street"
  end

  it "should create a customer given a card token customer email" do
    options = {number: "5520000000000000", expiry_month: "12", expiry_year: "2018", cvc: "123", name: "Roland TestRobot", address_line1: "123 Fake Road", address_line2: "", address_city: "Melbourne", address_postcode: "1223", address_state: "Vic", address_country: "AU"}
    @card = Pin::Card.create(options)
    Pin::Customer.create('nitza98@hotmail.com', @card['token'])['token'].should match(/^[a-z]{3}[_]/)
  end

end