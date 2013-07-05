module Pin
  class Charges < Base
    def self.all
      build_response(auth_get('charges'))
    end

    def self.find(token)
      build_response(auth_get("charges/#{token}"))
    end

    def self.search(options = {})
      term = ""
      options.each do |key, option|
        term += "#{key.to_s}=#{URI::encode(option)}&"
      end
      build_response(auth_get("charges/search?#{term}"))
    end

    def self.create(options = {})
      build_response(auth_post("charges", options))
    end
  end
end