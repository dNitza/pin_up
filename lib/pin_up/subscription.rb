module Pin
  ##
  # This class models Pins Subscription API
  class Subscription < Base
    ##
    # Lists all subscriptions for your account
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of subscription objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://www.pinpayments.com/developers/api-reference/subscriptions#get-subscriptions
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, { url: "subscriptions?page=#{page}" }), pagination)
    end

    ##
    # Create a subscription given subscription details
    # args: options (Hash)
    # returns: a subscription object
    # https://www.pinpayments.com/developers/api-reference/subscriptions#post-subscriptions
    def self.create(options = {})
      build_response(make_request(:post, { url: 'subscriptions', options: options }))
    end

    ##
    # Find a subscription for your account given a token
    # args: token (String)
    # returns: a subscription object
    # https://www.pinpayments.com/developers/api-reference/subscriptions#get-subscription
    def self.find(token)
      build_response(make_request(:get, { url: "subscriptions/#{token}" }))
    end

    ##
    # Update a subscription for your account given a token
    # and any of: email, card (hash),card_token
    # args: token (String), options (Hash)
    # returns: a subscription object
    # https://pin.net.au/docs/api/subscriptions#put-subscription
    # NB: When providing a card (hash), you need to specify
    # the full list of details.
    def self.update(token, card_token = nil)
      options = unless card_token.empty?
                  { card_token: card_token }
                else
                  card_token
                end
      build_response(make_request(:put, { url: "subscriptions/#{token}", options: options }))
    end

    ##
    # Delete (cancel) a subscription given a token
    # args: token (String)
    # returns: nil
    # https://www.pinpayments.com/developers/api-reference/subscriptions#delete-subscription
    def self.delete(token)
      build_response(make_request(:delete, { url: "subscriptions/#{token}" }))
    end

    ##
    # Reactivate a subscription given a token
    # args: token (String)
    # returns: nil
    # https://www.pinpayments.com/developers/api-reference/subscriptions#reactivate-subscription
    def self.reactivate(token)
      build_response(make_request(:put, { url: "subscriptions/#{token}/reactivate" }))
    end

    ##
    # Fetch all History for a subscription given a token
    # args: token (String)
    # returns: nil
    # https://www.pinpayments.com/developers/api-reference/subscriptions#history-subscription
    def self.history(token, page = nil, pagination = false)
      build_collection_response(make_request(:get, { url: "subscriptions/#{token}/history?page=#{page}" }), pagination)
    end
  end
end
