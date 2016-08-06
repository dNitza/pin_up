## pin_up

A Ruby gem wrapper for the pin-payments (pin.net.au) API, all of it.

Support for Ruby Ruby 2.x.x

[![Build Status](https://travis-ci.org/dNitza/pin_up.png)](https://travis-ci.org/dNitza/pin_up)
[![Code Climate](https://codeclimate.com/github/dNitza/pin_up.png)](https://codeclimate.com/github/dNitza/pin_up)

## Installation

    gem install pin_up

or add:

    gem 'pin_up'

to your Gemfile.

## Usage

If using rails add an initializer to your app:

    Pin::Base.new("your key", :env, timeout)

An optional second parameter can be passed in to set the environment (:live or :test). The default is :live.

An optional third parameter can be passed in to set the timeout of HTTParty in seconds. The default is `1800` (30 minutes).

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
##### Search For Charges
    Pin::Charges.search(query: "foo", end_date: "Mar 25, 2013")

Show found charges on a particular page:

    Pin::Charges.search(3, query: "foo", end_date: "Mar 25, 2013")

With Pagination:

    Pin::Charges.search(3, true, query: "foo", end_date: "Mar 25, 2013")
    # request = Pin::Charges.search(3, true, query: "foo", end_date: "Mar 25, 2013")
    # request[:response] => response hash
    # request[:pagination] => "pagination":{"current":3,"previous":2,"next":4,"per_page":25,"pages":10,"count":239}

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

##### Create A Customer Given a Card Token and Email

    card_details = {number: "5520000000000000", expiry_month: "12", expiry_year: "2018", cvc: "123", name: "Roland TestRobot", address_line1: "123 Fake Road", address_line2: "", address_city: "Melbourne", address_postcode: "1223", address_state: "Vic", address_country: "AU"}

    card = Pin::Card.create(card_details)
    Pin::Customer.create('email@example.com',card['token'])

##### List cards for a customer

    token = 'customer_token'
    Pin::Customer.cards(token)

##### Create a card for a customer (this does not replace their primary card)

    customer_token = 'customer_token'
    card = { number: '5520000000000000', expiry_month: '12', expiry_year: '2018', cvc: '123', name: 'Roland TestRobot', address_line1: '123 Fake Road', address_line2: '', address_city: 'Melbourne', address_postcode: '1223', address_state: 'Vic', address_country: 'AU' }
    Pin::Customer.create_card(customer_token, card)

You can also use a card token rather than a card hash

    customer_token = 'customer_token'
    card_token = 'card_token'
    Pin::Customer.create_card(customer_token, card_token)

##### Delete a card given a customer and a token
This method will raise an exception if attempting to remove the user's primary card
    
    customer_token = 'customer_token'
    card_token = 'card_token'
    Pin::Customer.delete_card(customer_token, card_token)

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


## Recipients
The recipients API allows you to post bank account details and retrieve a token that you can safely store in your app. You can send funds to recipients using the [transfers API].

##### Create a new recipient and returns its details
`options = { email: 'hello@example.com', name: 'Roland Robot', bank_account: { name: 'Roland Robot', bsb: '123456', number: 987654321 } } `

`Pin::Recipient.create(options)`

##### Get a paginated list of all recipients.
`Pin::Recipient.all `

##### Get the details of a recipient.
`Pin::Recipient.find(recipient_token) `

##### Update the given details of a recipient and return its details.
`Pin::Recipient.update(recipient_token, updated_options_hash)`

##### Get a paginated list of a recipient's transfers.
`Pin::Recipient.transfers(recipient_token) `

## Transfers
The transfers API allows you to send money to Australian bank accounts, and to retrieve details of previous transfers.

##### Create a new transfer and returns its details.
`transfer = { amount: 400, currency: 'AUD', description: 'Pay day', recipient: recipient_token } `

`Pin::Transfer.create(transfer) `

##### Get a paginated list of all transfers.
`Pin::Transfer.all `

##### Get the details of a transfer.
`Pin::Transfer.find(transfer_token)`

##### Search for transfers
    Pin::Transfer.search(query: "foo", end_date: "Mar 25, 2013")

Show found transfers on a particular page:

    Pin::Transfer.search(3, query: "foo", end_date: "Mar 25, 2013")

With Pagination:

    Pin::Transfer.search(3, true, query: "foo", end_date: "Mar 25, 2013")
    # request = Pin::Transfer.search(3, true, query: "foo", end_date: "Mar 25, 2013")
    # request[:response] => response hash
    # request[:pagination] => "pagination":{"current":3,"previous":2,"next":4,"per_page":25,"pages":10,"count":239}

See https://pin.net.au/docs/api/transfers#search-transfers for a full list of options.

##### Get the line items associated with transfer.
`Pin::Transfer.line_items(transfer_token)`

## Balance
The balance API allows you to see the current balance of funds in your Pin Payments account. You can use this to confirm whether a [transfer] is possible.

Returns the current balance of your Pin Payments account. Transfers can only be made using the funds in the `available` balance. The `pending` amount will become available after the 7 day settlement schedule on your charges.

`Pin::Balance.get `

## Bank Accounts
The bank account API allows you to securely store bank account details in exchange for a bank account token. This token can then be used to create a recipient using the [recipients API].
A bank account token can only be used once to create a recipient. The token automatically expires after 1 month if it hasn’t been used.

##### Create a bank account and return its details.
`options = { name: 'Roland Robot', bsb: '123456', number: '987654321' } `

`Pin::BankAccounts.create(options) `

## Receipts

Receipts have been extracted out into their [own gem](https://github.com/dNitza/pin_up_receipts)

## Exceptions

A number of different error types are built in:

### ResourceNotFound
The requested resource could not be found in Pin.

### InvalidResource
A number of parameters sent to Pin were invalid.

### ChargeError
Something went wrong while creating a charge in Pin. This could be due to insufficient funds, a card being declined or expired. A full list of possible errors is available [here](https://pin.net.au/docs/api/charges).

### InsufficientPinBalance

N.B. All of the above errors return an error object with a `message` and a `response` attribute. The response is the raw response from Pin (useful for logging).

### ClientError
An unsupported HTTP verb was used.

### Unauthorized
Authorization credentials are wrong. Most likely the authorization token needs to be checked.

## Testing locally
Create a YAML file under 'spec' called 'test_data.yml' and add in:

    PIN_SECRET: "your pin test secret"

uncomment line 13 in spec_helper.rb and

run

    rspec spec/*.rb

## Contributing to pin_up

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) Daniel Nitsikopoulos. See LICENSE.txt for
further details.
