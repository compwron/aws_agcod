require 'aws_agcod/request'

module AGCOD
  class AvailableFunds
    attr_reader :currency_code, :amount

    def initialize(payload)
      @currency_code = payload['currencyCode']
      @amount = payload['amount']
    end
  end
end

