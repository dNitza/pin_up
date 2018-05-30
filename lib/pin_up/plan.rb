module Pin
  ##
  # This class models Pins Plans API
  class Plan < Base
    ##
    # Lists all plans for your account
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of customer objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://www.pinpayments.com/developers/api-reference/plans

    ##
    # Create a plan given plan details
    # args: options (Hash)
    # returns: a plan object
    # https://www.pinpayments.com/developers/api-reference/plans
    def self.create(options = {})
      build_response(make_request(:post, { url: 'plans', options: options }))
    end
  end
end
