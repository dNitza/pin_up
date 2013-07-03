module Pin
  class Base
    include HTTParty

    def initialize(key: "", password: "", env: :live)
      @key = key
      env = env.to_sym
      @base_url = if env == :live
        "https://api.pin.net.au/1/"
      elsif env == :test
        "https://test-api.pin.net.au/1/"
      else
        raise "'env' option must be :live or :test. Leave blank for live payments"
      end
    end

    def key
      @key
    end

    def url
      @base_url
    end

    protected

    def self.get

    end

    def self.post()
      options = { body: {email: @school.email, description: "#{@plan.capitalize} Plan - My Focusbook", amount: "#{@price.to_i}00", currency: "AUD", ip_address: @school.ip_address,  card_token: @card_token}, basic_auth: {username: ENV["PIN_SECRET"], password:""}}
    end
  end
end