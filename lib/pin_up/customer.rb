module Pin
  ##
  # This class models Pins Customers API
  class Customer < Base

    ##
    # Lists all customers for your account
    # returns: a collection of customer objects
    # https://pin.net.au/docs/api/customers#get-customers
    def self.all(page=nil, pagination=false)
      build_collection_response(auth_get("customers?page=#{page}"), pagination)
    end

    ##
    # Create a customer given customer details and a card OR a card_token
    # args: email(String), card (Hash)
    # returns: a customer object
    # https://pin.net.au/docs/api/customers#post-customers
    def self.create(email, card)
      options = if card.respond_to?(:to_hash)
        {card: card.to_hash}
      else
        {card_token: card}
      end.merge(email: email)

      build_response(auth_post('customers', options))
    end

    ##
    # Find a customer for your account given a token
    # args: token (String)
    # returns: a customer object
    # https://pin.net.au/docs/api/customers#get-customers
    def self.find(token)
      build_response(auth_get("customers/#{token}"))
    end

    ##
    # Update a customer for your account given a token and any of: email, card (hash),card_token
    # args: token (String), options (Hash)
    # returns: a customer object
    # https://pin.net.au/docs/api/customers#put-customer
    # NB: When providing a card (hash), you need to specify the full list of details.
    def self.update(token, options = {})
      build_response(auth_put("customers/#{token}", options))
    end

    ##
    # Get a list of charges for a customer
    # args: token (String)
    # returns: a collection of charge objects
    # https://pin.net.au/docs/api/customers#get-customers-charges
    def self.charges(token)
      build_collection_response(auth_get("customers/#{token}/charges"))
    end
  end
end