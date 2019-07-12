module Pin
  ##
  # This class models Pin's Charges API
  class Refund < Base
    ##
    # Find a refund by charge token
    # returns: a collection of refund objects
    # args: token (String)
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pinpayments.com/docs/api/refunds#get-refunds
    def self.find(token, page = nil, pagination = false)
      build_collection_response(make_request(:get, { url: "charges/#{token}/refunds?page=#{page}" } ), pagination)
    end

    ##
    # Create a refund for a charge
    # args: token (String), amount (String - optional)
    # returns: a refund object
    # if no amount is passed in, the full amount of the charge will be refunded
    # https://pinpayments.com/docs/api/refunds#post-refunds
    def self.create(token, amount = nil)
      options = { amount: amount }
      build_response(make_request(:post, { url: "charges/#{token}/refunds", options: options } ))
    end
  end
end
