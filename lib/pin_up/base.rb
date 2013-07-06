module Pin
  ##
  # This class sets up a few things like the base URL and provides a few utility methods to be shared between classes.
  class Base
    include HTTParty

    ##
    # Create a new Pin instance
    # Args:
    #  key: Your Pin secret key
    #  env: The environment you want to use. Leave blank for live and pass in :test for test
    # An error is raised if an invalid env is passed in.
    def initialize(key = "", env = :live)
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

    ##
    # Provides access to your key if needed
    def key
      @key
    end

    ##
    # Provides access to the base URL if needed
    def uri
      @@base_url
    end

    protected

    ##
    # Sends an authorised GET request to pins server
    # args: url (eg: 'charges' or 'charges/token')
    def self.auth_get(url, token = nil)
      HTTParty.get("#{@@base_url}#{url}", basic_auth: @@auth)
    end

    ##
    # Sends an authorised POST request to pins server
    def self.auth_post(url, options = {})
      HTTParty.post("#{@@base_url}#{url}", body: options, basic_auth: @@auth)
    end

    ##
    # Sends an authorised PUT request to pins server
    def self.auth_put(url, options = {})
      HTTParty.put("#{@@base_url}#{url}", body: options, basic_auth: @@auth)
    end

    ##
    # Builds a response of a single object
    def self.build_response(response)
      response.parsed_response['response']
    end

    ##
    # Builds a response of a collection if the response code is 200 otherwise an empty array is returned
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