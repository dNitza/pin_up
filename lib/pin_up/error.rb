module Pin
  class PinError < StandardError

    def initialize(status = nil, message = nil)
      @status = status
      @message = message
    end

    def to_s
      "#{@status}: #{@message}"
    end
  end

  class InvalidRequest < PinError
    def initialize(status = nil, message = nil)
      super(status, message)
    end
  end
end