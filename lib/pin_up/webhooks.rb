module Pin
  ##
  # This class models Pin's WebhookEndpoints API
  class Webhooks < Base
    ##
    # Lists all webhooks
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of webhook objects
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pin.net.au/docs/api/webhooks#get-webhooks
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "webhooks?page=#{page}" } ), pagination)
    end

    ##
    # Find a webhook for your account given a token
    # args: token (String)
    # returns: a webhook object
    # https://pin.net.au/docs/api/webhooks#get-webhook
    def self.find(token)
      build_response(make_request(:get, {url: "webhooks/#{token}" } ))
    end

    ##
    # Replays a webhook
    # args: token (String)
    # https://pin.net.au/docs/api/webhooks#put-webhook-replay
    def self.replay(token)
      build_response(make_request(:put, {url: "webhooks/#{token}/replay" } ))
    end
  end
end
