module StripeWrapper
  class Charge
    attr_accessor :response, :status

    def initialize(response:, status:)
      self.response = response
      self.status = status
    end

    def self.create(amount:, source:, description:)
      begin
        response = Stripe::Charge.create currency: 'usd', amount: amount, source: source, description: description
        new response: response, status: :success
      rescue Stripe::CardError => error
        new response: error, status: :error
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
