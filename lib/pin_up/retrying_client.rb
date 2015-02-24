require 'pin_up/base'
require 'delegate'

class RetryingClient < DelegateClass(Pin::Base)
  def make_request(*, times: 3)
    super
  rescue
    retry if (times -= 1) > 0
    raise
  end
end