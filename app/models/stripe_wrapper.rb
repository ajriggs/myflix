module StripeWrapper
  class Charge
    attr_accessor :response, :status

    def initialize(response, status)
      self.response = response
      self.status = status
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create currency: 'usd', amount: options[:amount], source: options[:token], description: options[:description]
        new response, :success
      rescue Stripe::CardError => error
        new error, :error
      end
    end

    def error_message
      response.message if status == :error
    end

    def successful?
      status == :success
    end
  end
end
