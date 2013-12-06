require 'spec_helper'


describe "Refund", :vcr, class: Pin::Refund do
  before(:each) do
    Pin::Base.new(ENV["PIN_SECRET"], :test)
  end

  it "should list all refunds made to a charge given a token" do
    Pin::Refund.find('ch_S_3tP81Q9_sDngSv27gShQ')[0]['token'].should == "rf_O4lHrNzwXYmMmTbBq0ZLPw"
  end

  it "should return nothing if looking for a charge without a refund" do
    Pin::Refund.find('ch_rqPIWDK71YU46M4MAQHQKg').should == []
  end

  it "should return a page of refunds given a page and token" do
    Pin::Refund.find('ch_S_3tP81Q9_sDngSv27gShQ',1,true)[:response].should_not == []
  end

  it "should create a refund for a given amount and charge" do
    options = {email: "dNitza@gmail.com", description: "A new charge from testing Pin gem", amount: "400", currency: "AUD", ip_address: "127.0.0.1", customer_token: "cus_8ImkZdEZ6BXUA6NcJDZg_g"   }
    @charge = Pin::Charges.create(options)
    Pin::Refund.create(@charge['token'], "400")['amount'].should == 400
  end

end