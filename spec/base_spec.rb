require 'spec_helper'

describe "Base", :vcr, class: Pin::Base do
  before(:each) do
    @test_pin = Pin::Base.new(ENV["PIN_SECRET"], :test)
  end

  it "should set key correctly"  do
    @pin = Pin::Base.new("KEY", :live)
    expect(@pin.key).to eq "KEY"
  end

  it "should set environment to live if no env set" do
    @pin = Pin::Base.new("KEY", :live)
    expect(@pin.uri).to eq "https://api.pin.net.au/1/"
  end

  it "should set environment to test when set" do
    expect(@test_pin.uri).to eq "https://test-api.pin.net.au/1/"
  end

  it "should raise an error if anything other than '' :live or :test is passed to a new instance" do
    expect{Pin::Base.new("KEY", :foo)}.to raise_error(RuntimeError, "'env' option must be :live or :test. Leave blank for live payments")
  end

  it "should list succesfully connect to Pin" do
    stub_request(:get, "https://#{@test_pin.key}:''@test-api.pin.net.au/1/customers")
    expect(Pin::Base.auth_get('customers').code).to eq 200
  end
end
