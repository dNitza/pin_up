module Pin
  class Base
    include HTTParty

    def initialize(key: "", env: :live)
      @key = key
      env = env.to_sym
      @@auth = {username: key, password: ''}
      @@base_url = if env == :live
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

    def uri
      @@base_url
    end

    protected

    def self.auth_get(url, token: nil)
      HTTParty.get("#{@@base_url}#{url}", basic_auth: @@auth)
    end

    def self.auth_post(url, options = {})
      HTTParty.post("#{@@base_url}#{url}", body: options, basic_auth: @@auth)
    end

    def self.auth_put(url, options = {})
      HTTParty.put("#{@@base_url}#{url}", body: options, basic_auth: @@auth)
    end

    def self.build_response(response)
      response.parsed_response['response']
    end

    def self.build_collection_response(response)
      models = []
      if response.code == 200
        response.parsed_response['response'].each do |model|
          models << model
        end
      end
      models
    end
  end
end