module Pin
  ##
  # This class models Pin's Bank Accounts API
  class BankAccounts < Base
    ##
    # Creates a bank account token and returns its details.
    #
    # The bank account API allows you to securely store bank account details in exchange for a bank account token.
    # This token can then be used to create a recipient using the recipients API.
    #
    # A bank account token can only be used once to create a recipient.
    # The token automatically expires after 1 month if it hasn’t been used.
    #
    # https://pinpayments.com/docs/api/bank-accounts
    def self.create(options)
      build_response(make_request(:post, { url: 'bank_accounts', options: options }))
    end
  end
end
