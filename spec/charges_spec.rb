require 'spec_helper'

describe "Charge", :vcr, class: Pin::Charges do
  before(:each) do
    Pin::Base.new(ENV["PIN_SECRET"], :test)
  end

  it "should list charges in Pin" do
    Pin::Charges.all.should_not == []
  end

  it "should show a charge given a token" do
    Pin::Charges.find("ch_0kdOMXP7gG0_W_Vh8qAWdA")["token"].should match(/^[a-z]{2}[_]/)
  end

  it "should show a charge given a search term" do
    Pin::Charges.search({query: "mid Plan - My Focusbook", end_date: "Mar 25, 2013"}).should_not == []
  end

  it "should not show a charge if end_date is out of range" do
    Pin::Charges.search({end_date: "Mar 25, 2011"}).should == []
  end

  it "should create a charge given details" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", customer_token: "cus_8ImkZdEZ6BXUA6NcJDZg_g"   }
    Pin::Charges.create(options)["success"].should eq true
  end

  it "should return pagination if 'pagination' is true" do
    Pin::Charges.all(3,true)[:pagination]["current"] == 3
  end

  it "should list charges on a page given a page" do
    Pin::Charges.all(1).should_not == []
  end
end