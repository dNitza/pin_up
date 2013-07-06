module Pin
  ##
  # This class models Pin's Charges API
  class Charges < Base
    ##
    # Lists all of the charges for your account
    # returns: a collection of charge objects
    # https://pin.net.au/docs/api/charges#get-charges
    def self.all
      build_response(auth_get('charges'))
    end

    ##
    # Find a charge for your account given a token
    # args: token (String)
    # returns: a charge object
    # https://pin.net.au/docs/api/charges#get-charge
    def self.find(token)
      build_response(auth_get("charges/#{token}"))
    end

    # Find a charge(s) for your account given a search term or set of terms
    # args: options (Hash)
    # returns: a collection of charge objects
    # https://pin.net.au/docs/api/charges#search-charges
    def self.search(options = {})
      term = ""
      options.each do |key, option|
        term += "#{key.to_s}=#{URI::encode(option)}&"
      end
      build_response(auth_get("charges/search?#{term}"))
    end

    # Create a charge given charge details and a card, a card_token or acustomer_token
    # args: options (Hash)
    # returns: a charge object
    # https://pin.net.au/docs/api/charges#post-charges
    def self.create(options = {})
      build_response(auth_post("charges", options))
    end
  end
end