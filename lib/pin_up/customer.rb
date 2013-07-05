module Pin
  class Customer < Base

    def self.all
      build_collection_response(auth_get('customers'))
    end

    def self.create(email, card)
      options = if card.respond_to?(:to_hash)
        {card: card.to_hash}
      else
        {card_token: card}
      end.merge(email: email)

      build_response(auth_post('customers', options))
    end

    def self.find(token)
      build_response(auth_get("customers/#{token}"))
    end

    def self.update(token, options = {})
      build_response(auth_put("customers/#{token}", options))
    end

    def self.charges(token)
      build_collection_response(auth_get("customers/#{token}/charges"))
    end
  end
end