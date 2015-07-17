module Pin
  ##
  # This class models Pin's Balance API
  class Balance < Base
    ##
    # Returns the current balance of your Pin Payments account.
    # Transfers can only be made using the funds in the available balance.
    # The pending amount will become available after the 7 day settlement schedule on your charges.
    #
    # https://pin.net.au/docs/api/balance
    def self.get
      build_response(make_request(:get, { url: 'balance' }))
    end
  end
end
