module Pin
  class PinError < Exception

    def initialize(message=nil, http_status=nil)
      @message = message
      @http_status = http_status
    end

    def to_s
      status_string = @http_status.nil? ? "" : "(Status #{@http_status}) "
      "#{status_string}#{@message}"
    end

    def self.handle_error(http_status, response)
      case http_status
      when 400
        raise(Pin::ChargeError, "#{response['error']}: #{response['error_description']}. Charge token: #{response['charge_token']}")
      when 402
        raise(Pin::InsufficientPinBalance, "#{response['error_description']}")
      when 404
        raise(Pin::ResourceNotFound, "#{response['error_description']}")
      when 422
        message = ""
        response['messages'].each do |m|
          message += "#{m['code']}: #{m['message']}"
        end
        raise(Pin::InvalidResource, message)
      end
    end
  end

  class ResourceNotFound < PinError
  end

  class InvalidResource < PinError
  end

  class ChargeError < PinError
  end

  class InsufficientPinBalance <PinError
  end

end