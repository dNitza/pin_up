# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: pin_up 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pin_up".freeze
  s.version = "1.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Nitsikopoulos".freeze]
  s.date = "2018-06-15"
  s.description = "A Ruby gem wrapper for the pin-payments (pinpayments.com) API".freeze
  s.email = "dnitza@gmail.com".freeze
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".travis.yml",
    "CHANGELOG.md",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "build",
    "lib/pin_up.rb",
    "lib/pin_up/balance.rb",
    "lib/pin_up/bank_accounts.rb",
    "lib/pin_up/base.rb",
    "lib/pin_up/card.rb",
    "lib/pin_up/charge.rb",
    "lib/pin_up/client.rb",
    "lib/pin_up/customer.rb",
    "lib/pin_up/pin_errors.rb",
    "lib/pin_up/plan.rb",
    "lib/pin_up/recipient.rb",
    "lib/pin_up/refund.rb",
    "lib/pin_up/subscription.rb",
    "lib/pin_up/transfer.rb",
    "lib/pin_up/webhook_endpoints.rb",
    "pin_up.gemspec",
    "spec/balance_spec.rb",
    "spec/bank_accounts_spec.rb",
    "spec/base_spec.rb",
    "spec/cards_spec.rb",
    "spec/charges_spec.rb",
    "spec/client_spec.rb",
    "spec/customers_spec.rb",
    "spec/errors_spec.rb",
    "spec/plan_spec.rb",
    "spec/recipients_spec.rb",
    "spec/refund_spec.rb",
    "spec/spec_helper.rb",
    "spec/subscription_spec.rb",
    "spec/transfers_spec.rb",
    "spec/webhook_endpoints_spec.rb"
  ]
  s.homepage = "http://github.com/dNitza/pin_up".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "A Ruby gem wrapper for the pin-payments API".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>.freeze, ["= 0.17.0"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.12"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7.0"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.7.1"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 3.6.0"])
      s.add_development_dependency(%q<vcr>.freeze, ["~> 4.0.0"])
    else
      s.add_dependency(%q<httparty>.freeze, ["= 0.17.0"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<httparty>.freeze, ["= 0.17.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
  end
end

