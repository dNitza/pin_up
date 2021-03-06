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

    ##
    # Update a plan given a token
    # args: token (String), options (Hash)
    # returns: a plan object
    # https://www.pinpayments.com/developers/api-reference/plans#put-plan
    def self.update(token, options = {})
      build_response(make_request(:put, { url: "plans/#{token}", options: options }))
    end

    ##
    # Delete a plan given a token
    # args: token (String)
    # returns: nil
    # https://www.pinpayments.com/developers/api-reference/plans#delete-plan
    def self.delete(token)
      build_response(make_request(:delete, { url: "plans/#{token}" } ))
    end

    ##
    # List Subscriptions associated with a plan given a token
    # args: token (String)
    # returns: nil
    # 
    def self.subscriptions(token, page = nil, pagination = false)
      build_collection_response(make_request(:get, { url: "plans/#{token}/subscriptions" } ), pagination)
    end

    ##
    # Create a subscription for a plan given a customer_token OR a card_token
    # args: customer_token (String), card (String) see docs.
    # returns: a subscription object
    #
    def self.create_subscription(token, customer_token, card_token = nil)
      options = if card_token
                  { customer_token: customer_token,
                    card_token: card_token}
                else
                  { customer_token: customer_token }
                end

      build_response(make_request(:post, {url: "plans/#{token}/subscriptions", options: options} ))
    end
  end
end
