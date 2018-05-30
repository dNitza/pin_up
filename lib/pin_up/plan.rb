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
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "plans?page=#{page}" } ), pagination)
    end

    ##
    # Create a plan given plan details
    # args: options (Hash)
    # returns: a plan object
    # https://www.pinpayments.com/developers/api-reference/plans
    def self.create(options = {})
      build_response(make_request(:post, { url: 'plans', options: options }))
    end

    ##
    # Find a plan for your account given a token
    # args: token (String)
    # returns: a plan object
    # https://www.pinpayments.com/developers/api-reference/plans#get-plan
    def self.find(token)
      build_response(make_request(:get, {url: "plans/#{token}" } ))
    end
  end
end
