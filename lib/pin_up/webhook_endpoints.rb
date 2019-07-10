module Pin
  ##
  # This class models Pin's WebhookEndpoints API
  class WebhookEndpoints < Base
    ##
    # Lists all webhook endpoints for your account
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of webhook endpoint objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pinpayments.com/docs/api/webhook_endpoints#get-webhook_endpoints
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "webhook_endpoints?page=#{page}" } ), pagination)
    end

    ##
    # creates a webhook endpoint given a hash of options
    # https://pinpayments.com/docs/api/webhook_endpoints
    # args: url (Hash)
    # returns: webhook object
    def self.create(options)
      build_response(make_request(:post, { url: 'webhook_endpoints', options: options }))
    end

    ##
    # Find a webhook endpoint for your account given a token
    # args: token (String)
    # returns: a webhook endpoint object
    # https://pinpayments.com/docs/api/webhook_endpoints#get-webhook_endpoints
    def self.find(token)
      build_response(make_request(:get, {url: "webhook_endpoints/#{token}" } ))
    end

    ##
    # Delete a webhook endpoint for your account given a token
    # args: token (String)
    # returns: nil
    # https://pinpayments.com/docs/api/webhook_endpoints#delete-webhook_endpoints
    def self.delete(token)
      build_response(make_request(:delete, {url: "webhook_endpoints/#{token}" } ))
    end
  end
end
