module Pin
  ##
  # This class lets you generate and save receipts from a Pin::Charge.
  class Receipt < Pin::Base

    ##
    # Create a new Pin::Receipt instance
    # Args:
    #  charge: Charge hash from Pin::Charge.find
    #  your_details: (Array), an Array of details you would like displayed about you or your company
    #  payment_options: (Hash), If your charge had extra components (such as late fees or discounts or taxes) pass them in here as a hash eg:
    #
    #     payment_options = {}
    #     payment_options["fee"] = {"name" => "late fee", "amount" => "$10.00"}
    #     payment_options["tax"] = {"name" => "GST", "amount" => "$10.00"}
    #     payment_options["discount"] = {"name" => "Member Discount", "amount" => "$10.00"}
    #
    #  template_path: (String), path to your own template if you wish to design your own receipt (take a look at the included template for variable names)
    #  save_path: (String), path that the HTML receipt will be saved
    def initialize(charge, your_details, logo_path='', payment_options={}, template_path = 'views/receipt.html.erb', save_path = 'tmp/receipt.html')
      @charge = charge
      @logo = logo_path
      @details = your_details
      @payment_options = payment_options
      @template_path = template_path if template_path
      @save_path = save_path if save_path
      @amount = number_to_currency(@charge["amount"], @charge["currency"])
    end

    ##
    # Renders the HTML receipt but does not save it -- useful for showing on screen
    def render
      template = ERB.new File.new(@template_path).read, nil, "%"
      template.result(binding)
    end

    ##
    # Renders and saves the HTML receipt -- useful for emailing receipt
    def save
      receipt = File.new(@save_path, 'w')
      receipt.write(render)
      receipt.close
    end

    protected

    ##
    # Converts a string to currency format.
    # Args:
    #  number: (String) a dollar, pound or euro value in 'cents'
    #  currency: (String) a string representation of a currency as provided by Pin
    def number_to_currency(number, currency)
      case currency
      when 'GBP'
        symbol = '£'
      when 'EUR'
        symbol = '€'
      else
        symbol = '$'
      end
      "#{symbol}#{"%0.2f" % (number.to_f / 100)}"
    end
  end
end