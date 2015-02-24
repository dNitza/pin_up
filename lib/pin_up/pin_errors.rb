module Pin
  ##
  # Base Pin Eror class
  class PinError < Exception
    def initialize(message = nil, http_status = nil)
      @message = message
      @http_status = http_status
    end

    def to_s
      status_string = @http_status.nil? ? '' : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end

    def self.handle_error(http_status, response)
      case http_status
      when 400
        fail(Pin::ChargeError, "#{response['error']}: #{response['error_description']}. Charge token: #{response['charge_token']}")
      when 402
        fail(Pin::InsufficientPinBalance, "#{response['error_description']}")
      when 404
        fail(Pin::ResourceNotFound, "#{response['error_description']}")
      when 422
        message = handle_bad_response(response)
        fail(Pin::InvalidResource, message)
      end
    end

    def self.handle_bad_response(response)
      message = ''
      begin
        response['messages'].each do |m|
          message += "#{m['code']}: #{m['message']}"
        end
      rescue
        begin response['messages']['amount'][0]
          message = "#{response['error']}: #{response['error_description']}. Amount: #{response['messages']['amount'][0]}"
        rescue
          message = "#{response['error']}: #{response['error_description']}"
        end
      end
      message
    end

    def self.handle_bad_request
      message = "request :method must be one of get, post, put, patch or delete"
    end
  end

  class ResourceNotFound < PinError
  end

  class InvalidResource < PinError
  end

  class ChargeError < PinError
  end

  class InsufficientPinBalance < PinError
  end
end
