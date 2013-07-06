require 'spec_helper'


describe "Refund", :vcr, class: Pin::Refund do
  before(:each) do
    Pin::Base.new("W_VrFld7oc9BnC4pOdQxmw", :test)
  end

  it "should list all refunds made to a charge given a token" do
    Pin::Refund.find('ch_S_3tP81Q9_sDngSv27gShQ')[0]['token'].should == "rf_O4lHrNzwXYmMmTbBq0ZLPw"
  end

  it "should return nothing if looking for a charge without a refund" do
    Pin::Refund.find('ch_rqPIWDK71YU46M4MAQHQKg').should == []
  end

  it "should create a refund for a given amount and charge" do
    Pin::Refund.create('ch_NLEbb_xRgtyz58RGQ5zVqg', "400")['amount'].should == 400
  end

  it "should create a refund for the entire amount of a charge if no amount given" do
    Pin::Refund.create('ch_QG_2Gl5x47WEzTdBIwnluQ')['amount'].should == 7900
  end

end