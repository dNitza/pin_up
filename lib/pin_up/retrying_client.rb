module Pin
  require 'delegate'

  class RetryingClient < DelegateClass(Pin::Client)
    def make_request(*, times: 3)
      super
    rescue
      retry if (times -= 1) > 0
      raise
    end
  end
end