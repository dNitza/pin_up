module Pin
  ##
  # This class sets up a few things like the base URL and provides a few
  # utility methods to be shared between classes.
  class Base
    include HTTParty

    attr_reader :key
    ##
    # Create a new Pin instance
    # Args:
    #  key: Your Pin secret key
    #  env: The environment you want to use.
    #    Leave blank for live and pass :test for test
    # An error is raised if an invalid env is passed in.
    def initialize(key = '', env = :live, timeout = 1800)
      @key = key
      env = env.to_sym
      @@auth = { username: @key, password: '' }
      @@timeout = timeout
      @@base_url = if env == :live
                     'https://api.pin.net.au/1/'
                   elsif env == :test
                     'https://test-api.pin.net.au/1/'
                   else
                     fail "'env' option must be :live or :test. Leave blank for live payments"
                   end
    end

    ##
    # Provides access to the base URL if needed
    def base_uri
      @@base_url
    end

    ##
    # Sends an authenticated request to pin's server
    # args: method (Symbol), args (Hash)
    # eg. args => { url: 'cards', options: { ... } }
    def self.make_request(method, args)
      Pin::Client.new(method, args, @@base_url, @@auth, @@timeout).make_request
    end

    ##
    # Builds a response of a single object
    def self.build_response(response)
      if response.code >= 400
        Pin::PinError.handle_error(response.code, response.parsed_response)
      elsif response.code == 204
        response
      else
        response.parsed_response['response']
      end
    end

    ##
    # Builds a response of a collection if the response code is 200
    #  otherwise an empty array is returned
    def self.build_collection_response(response, pagination = false)
      models = []
      if response.code == 200
        if pagination
          response.parsed_response['response'].each do |model|
            models << model
          end
          return {
            response: models,
            pagination: response.parsed_response['pagination']
          }
        else
          response.parsed_response['response'].each do |model|
            models << model
          end
        end
      elsif response.code >= 400
        Pin::PinError.handle_error(response.code, response.parsed_response)
      end
      # models
    end
  end
end
