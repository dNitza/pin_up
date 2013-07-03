require 'spec_helper'

describe "Base", class: Pin::Base do
  before(:each) do
    @pin = Pin::Base.new(key: "KEY")
  end

  it "should set key correctly"  do
    expect(@pin.key).to eq "KEY"
  end

  it "should set environment to live if no env set" do
    expect(@pin.url).to eq "https://api.pin.net.au/1/"
  end

  it "should set environment to test when set" do
    @test_pin = Pin::Base.new(key: "KEY", env: :test)
    expect(@test_pin.url).to eq "https://test-api.pin.net.au/1/"
  end

  it "should raise an error if anything other than '' :live or :test is passed to a new instance" do
    expect{Pin::Base.new(key: "KEY", env: :foo)}.to raise_error(RuntimeError, "'env' option must be :live or :test. Leave blank for live payments")
  end

  it "should make a get request to the base uri" do

  end
end