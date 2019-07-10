module Pin
  ##
  # This class models Pin's Recipient API
  class Recipient < Base
    ##
    # Creates a new recipient and returns its details.
    # https://pinpayments.com/docs/api/recipients#post-recipients
    # args: options (Hash)
    # returns: recipient (Hash)
    def self.create(options)
      build_response(make_request(:post, { url: 'recipients', options: options }))
    end

    ##
    # Lists all recipients for your account
    # args: page (Fixnum), pagination (Boolean)
    # returns: a collection of recipients
    #
    # if pagination is passed, access the response hash with [:response]
    # and the pagination hash with [:pagination]
    #
    # https://pinpayments.com/docs/api/recipients#get-recipients
    def self.all(page = nil, pagination = false)
      build_collection_response(make_request(:get, {url: "recipients?page=#{page}" } ), pagination)
    end

    ##
    # Find a recipient for your account given a token
    # args: token (String)
    # returns: a recipient
    # https://pinpayments.com/docs/api/recipients#get-recipient
    def self.find(token)
      build_response(make_request(:get, {url: "recipients/#{token}" } ))
    end

    ##
    # Update a recipient for your account given a token
    # and any of: email, name, bank_account (hash)
    # args: token (String), options (Hash)
    # returns: a recipient
    # https://pinpayments.com/docs/api/recipients#put-recipient
    def self.update(token, options = {})
      build_response(make_request(:put, { url: "recipients/#{token}", options: options }))
    end

    def self.transfers(token, pagination = false)
      build_collection_response(make_request(:get, { url: "recipients/#{token}/transfers" } ), pagination)
    end
  end
end
