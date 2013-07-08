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

  it "should create a refund for a given amount and charge" do
    @charge = Pin::Charges.search({query: "1000"})[0]
    Pin::Refund.create(@charge['token'], "400")['amount'].should == 400
  end

  #having issues with Pin raising a 500 error with this one.
  # xit "should create a refund for the entire amount of a charge if no amount given" do
  #   @charge = Pin::Charges.search({query: "1000"})[1]
  #   @refund = Pin::Refund.create(@charge['token'])
  #   raise @refund.inspect
  #   @refund['amount'].should == @charge['amount']
  # end

end