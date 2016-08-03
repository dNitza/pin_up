module Pin
  ##
  # This class models Pin's Charges API
  class Charges < Base
    ##
    # Lists all of the charges for your account
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of charge objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pin.net.au/docs/api/charges#get-charges
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, { url: "charges?page=#{page}" }), pagination)
    end

    ##
    # Find a charge for your account given a token
    # args: token (String)
    # returns: a charge object
    # https://pin.net.au/docs/api/charges#get-charge
    def self.find(token)
      build_response(make_request(:get, {url: "charges/#{token}" } ))
    end

    # Find a charge(s) for your account given a search term or set of terms
    # args: options (Hash)
    # returns: a collection of charge objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pin.net.au/docs/api/charges#search-charges
    def self.search(page = nil, pagination = false, **options)
      term = ''
      options.merge! page: page if page

      options.each do |key, option|
        term += "#{key.to_s}=#{URI.encode(option.to_s)}&"
      end
      build_collection_response(make_request(:get, {url: "charges/search?#{term}" } ), pagination)
    end

    # Create a charge given charge details and a card,
    # a card_token or a customer_token
    # args: options (Hash)
    # returns: a charge object
    # https://pin.net.au/docs/api/charges#post-charges
    def self.create(options = {})
      build_response(make_request(:post, {url: 'charges', options: options} ))
    end

    # Captures a previously authorised charge and returns its details.
    # args: charge-token (String)
    # returns: charge object
    # https://pin.net.au/docs/api/charges#put-charges
    def self.capture(token)
      build_response(make_request(:put, { url: "charges/#{token}/capture" } ))
    end
  end
end
