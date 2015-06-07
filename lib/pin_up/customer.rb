module Pin
  ##
  # This class models Pins Customers API
  class Customer < Base
    ##
    # Lists all customers for your account
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of customer objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pin.net.au/docs/api/customers#get-customers
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "customers?page=#{page}" } ), pagination)
    end

    ##
    # Create a customer given customer details and a card OR a card_token
    # args: email(String), card (Hash)
    # returns: a customer object
    # https://pin.net.au/docs/api/customers#post-customers
    def self.create(email, card)
      options = if card.respond_to?(:to_hash)
        { card: card.to_hash }
      else
        { card_token: card }
      end.merge(email: email)

      build_response(make_request(:post, { url: 'customers', options: options }))
    end

    ##
    # Find a customer for your account given a token
    # args: token (String)
    # returns: a customer object
    # https://pin.net.au/docs/api/customers#get-customers
    def self.find(token)
      build_response(make_request(:get, {url: "customers/#{token}" } ))
    end

    ##
    # Update a customer for your account given a token
    # and any of: email, card (hash),card_token
    # args: token (String), options (Hash)
    # returns: a customer object
    # https://pin.net.au/docs/api/customers#put-customer
    # NB: When providing a card (hash), you need to specify
    # the full list of details.
    def self.update(token, options = {})
      build_response(make_request(:put, { url: "customers/#{token}", options: options }))
    end

    ##
    # Get a list of charges for a customer
    # args: token (String), page (Fixnum), pagination (Boolean)
    # returns: a collection of charge objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pin.net.au/docs/api/customers#get-customers-charges
    def self.charges(token, page = nil, pagination = false)
      build_collection_response(
        make_request(:get, {url: "customers/#{token}/charges?page=#{page}" }), pagination
      )
    end

    ##
    # Get a list of cards for a customer
    # args: token (String), page (Fixnum), pagination (Boolean)
    # returns: a collection of cards objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pin.net.au/docs/api/customers#get-customers-cards
    def self.cards(token, page = nil, pagination = false)
      build_collection_response(
        make_request(:get, {url: "customers/#{token}/cards?page=#{page}" }), pagination
      )
    end

    ##
    # Create a card for customer given a card OR a card_token
    # args: customer_token (String), card (Hash) or (String) see docs.
    # returns: a card object
    # https://pin.net.au/docs/api/customers#post-customers-cards
    def self.create_card(token, card)
      options = if card.respond_to?(:to_hash)
        card
      else
        { card_token: card }
      end

      build_response(make_request(:post, {url: "customers/#{token}/cards", options: options} ))
    end

    ##
    # Deletes a card for customer given a card_token
    # args: customer_token (String), card_token (String)
    # returns: a card object
    # https://pin.net.au/docs/api/customers#delete-customers-card
    def self.delete_card(token, card_token)
      build_response(make_request(:delete, {url: "customers/#{token}/cards/#{card_token}"} ))
    end
  end
end
