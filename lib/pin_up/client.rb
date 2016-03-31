module Pin
  class Client
    def initialize(method, args, base_url, auth, timeout)
      @method = method
      @args = args
      @base_url = base_url
      @auth = auth
      @timeout = timeout
    end

    ##
    # Sends an authenticated request to pin's server
    # args: method (Symbol), args (Hash)
    # eg. args => { url: 'cards', options: { ... } }
    def make_request
      if %i(get post put patch delete).include? @method
        HTTParty.send(@method, "#{@base_url}#{@args[:url]}", body: @args[:options], basic_auth: @auth, timeout: @timeout)
      else
        Pin::PinError.handle_bad_request
      end
    end
  end
end
