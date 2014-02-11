## pin_up

A Ruby gem wrapper for the pin-payments (pin.net.au) API, all of it.

Support for Ruby 1.9.x & Ruby 2.0.0

[![Build Status](https://travis-ci.org/dNitza/pin_up.png)](https://travis-ci.org/dNitza/pin_up)

## Installation

    gem install pin_up

or add:

    gem 'pin_up'

to your Gemfile.

## Usage

If using rails add an initializer to your app:

    Pin::Base.new("your key")

An option second paramater can be passed in to set the environment (:live or :test). The default is :live.

### Charges
##### List All Charges
    Pin::Charges.all

Show charges on a particular page:

    Pin::Charges.all(6)

With Pagination:

    Pin::Charges.all(6,true)
    # request = Pin::Charges.all(6,true)
    # request[:response] => response hash
    # request[:pagination] => "pagination":{"current":6,"previous":5,"next":7,"per_page":25,"pages":1,"count":15}

##### Find A Charge
    Pin::Charges.find("token")
##### Search For A Charge
    Pin::Charges.search({query: "foo", end_date: "Mar 25, 2013"})

See https://pin.net.au/docs/api/charges#search-charges for a full list of options.

##### Create A Charge
    charge = {email: "email@example.com", description: "Description", amount: "400", currency: "AUD", ip_address: "127.0.0.1", customer_token: "cus_token"   }

    Pin::Charges.create(charge)

##### Authorise A Charge (but don't charge it yet)
Also known as a pre-auth, this will hold a charge to be captured by for up to 5 days

    charge = {email: "email@example.com", description: "Description", amount: "400", currency: "AUD", ip_address: "127.0.0.1", customer_token: "cus_token"  capture: false }

    Pin::Charges.create(charge)

##### Capture an authorised charge
    Pin::Charges.capture(charge)

### Customers
##### List All Customers
    Pin::Customer.all

Show customers on a particular page:

    Pin::Customer.all(3)

With Pagination:

    Pin::Customer.all(3,true)

##### Find A Customer
    Pin::Customer.find('token')
##### List Charges For A Customer
    Pin::Customer.charges('cus_token')

Show customers on a particular page:

    Pin::Customer.charges(6)

With Pagination:

    Pin::Customer.all(6,true)
    # request = Pin::Customer.all(6,true)
    # request[:response] => response hash
    # request[:pagination] => "pagination":{"current":6,"previous":5,"next":7,"per_page":25,"pages":1,"count":15}

##### Create A Customer
    Pin::Customer.create(email, hash_of_customer_details)

    customer_details = {number: '5520000000000000', expiry_month: "12", expiry_year: "2014", cvc: "123", name: 'Roland Robot', address_line1: '123 fake street', address_city: 'Melbourne', address_postcode: '1234', address_state: 'Vic', address_country: 'Australia'}

    Pin::Customer.create('email@example.com', customer_details)

##### Update A Customer
###### Update Card details
---
    Pin::Customer.update('cus_token', hash_of_details)

If passing a hash of details, it must be the full list of details of the credit card to be stored. (https://pin.net.au/docs/api/customers#put-customer)

###### Update only an email
---

    hash_of_details = {email: 'new_email@example.com'}
    Pin::Customer.update('cus_token', hash_of_details)

###### Update card by token
---

    hash_of_details = {card_token: 'new_card_token'}
    Pin::Customer.update('cus_token', hash_of_details)

##### Creat A Customer Given a Card Token and Email

    card_details = {number: "5520000000000000", expiry_month: "12", expiry_year: "2018", cvc: "123", name: "Roland TestRobot", address_line1: "123 Fake Road", address_line2: "", address_city: "Melbourne", address_postcode: "1223", address_state: "Vic", address_country: "AU"}

    card = Pin::Card.create(card_details)
    Pin::Customer.create('email@example.com',card['token'])

## Refunds

##### Find A Refund

    Pin::Refund.find('charge_token')

This will list all refunds for a particular charge (will return an empty hash if nothing is found)

##### Create A Refund Specifying An Amount

    Pin::Refund.create('charge_token', '400')

##### Create A Refund For Entire Charge Amount

    Pin::Refund.create('charge_token')

## Cards

##### Create A Card Without Pins Form

    card_details = {number: "5520000000000000", expiry_month: "12", expiry_year: "2018", cvc: "123", name: "Roland Robot", address_line1: "123 Fake Road", address_line2: "", address_city: "Melbourne", address_postcode: "1223", address_state: "Vic", address_country: "AU"}

    Pin::Card.create(card_details)

Will return a card_token that can be stored against a customer.

Only use this method if you're comfortable sending card details to your server - otherwise you can use a form that Pin provides (https://pin.net.au/docs/guides/payment-forms) and get the card_token that way.

## Receipts

Receipts have been extracted out into their [own gem](https://github.com/dNitza/pin_up_receipts)

## Testing localy
Create a YAML file under 'spec' called 'test_data.yml' and add in:

    PIN_SECRET: "your pin test secret"

uncomment line 13 in spec_helper.rb and

run

    rspec spec/*.rb

## To do

  * Validate a response before it gets sent to Pin (eg. Update customer)

## Contributing to pin_up

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2013 Daniel Nitsikopoulos. See LICENSE.txt for
further details.