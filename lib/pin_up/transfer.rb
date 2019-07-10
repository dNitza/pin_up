module Pin
  ##
  # This class models Pin's Transfers API
  class Transfer < Base
    ##
    # Creates a new transfer and returns its details.
    # https://pinpayments.com/docs/api/transfers#post-transfers
    # args: options (Hash)
    def self.create(options)
      build_response(make_request(:post, { url: 'transfers', options: options }))
    end

    ##
    # Returns a paginated list of all transfers.
    # page: page (Fixnum), pagination (Boolean)
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pinpayments.com/docs/api/transfers#get-transfers
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "transfers?page=#{page}" } ), pagination)
    end

    ##
    # Returns the details of a transfer.
    # args: token (String)
    # returns: a transfer
    # https://pinpayments.com/docs/api/transfers#get-transfer
    def self.find(token)
      build_response(make_request(:get, {url: "transfers/#{token}" } ))
    end

    # Find a transfer(s) for your account given a search term or set of terms
    # args: options (Hash)
    # returns: a collection of transfer objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pinpayments.com/docs/api/transfers#search-transfers
    def self.search(page = nil, pagination = false, **options)
      term = ''
      options.merge! page: page if page

      options.each do |key, option|
        term += "#{key.to_s}=#{URI.encode(option.to_s)}&"
      end
      build_collection_response(make_request(:get, {url: "transfers/search?#{term}" } ), pagination)
    end

    ##
    # Returns the line items associated with transfer.
    # args: token (String), page (Fixnum), pagination (Boolean)
    #
    # https://pinpayments.com/docs/api/transfers#get-transfer-line-items
    def self.line_items(token, page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "transfers/#{token}/line_items?page=#{page}" } ), pagination)
    end
  end
end
