require 'aws_agcod/request'

module AGCOD
  class GetAvailableFunds
    extend Forwardable

    def_delegators :@response, :currency_code, :amount

    def initialize(httpable, partner_id)
      @response = Request.new(httpable, 'GetAvailableFunds',
        'partnerId' => partner_id,
      ).response
    end

    def available_funds
      @response.payload['availableFunds'].map { |payload| AvailableFunds.new(payload) }
    end

    def timestamp
      Time.parse(@response.payload['timestamp'])
    end

    def status
      @response.payload['status']
    end
  end
end
