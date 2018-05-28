require 'codeclimate-test-reporter'
require 'simplecov'

CodeClimate::TestReporter.start
SimpleCov.start

require 'rubygems'
require 'bundler/setup'
require 'webmock/rspec'
require 'vcr'

require 'net/https'
require 'uri'

## Uncomment to load in a .yml with your pin key
# ENV.update YAML.load(File.read(File.expand_path('../test_data.yml', __FILE__)))

# require pin_up gem
require 'pin_up'

RSpec.configure do |config|
  config.include WebMock::API
  config.around(:each, :vcr) do |example|
    name = example
          .metadata[:full_description]
          .split(/\s+/, 2).join('/')
          .gsub(/[^\w\/]+/, '_')
    options = example.metadata.slice(:record, :match_on_requests_on)
    VCR.use_cassette(name, options) { example.call }
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end
