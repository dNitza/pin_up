require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'
require 'vcr'

require "net/https"
require "uri"

#gem
require 'pin-payments'

RSpec.configure do |config|
  config.include WebMock::API
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").gsub(/[^\w\/]+/, "_")
    # options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name) { example.call }
  end
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr"
  c.hook_into :webmock
  c.filter_sensitive_data('<key>') {'W_VrFld7oc9BnC4pOdQxmw'}
end