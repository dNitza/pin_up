module Pin
  class Refund < Base

    def self.find(token)
      build_collection_response(auth_get("charges/#{token}/refunds"))
    end

    def self.create(token, amount = nil)
      options = {amount: amount}
      build_response(auth_post("charges/#{token}/refunds", options))
    end
  end
end