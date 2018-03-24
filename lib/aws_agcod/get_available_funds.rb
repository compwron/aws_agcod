require 'aws_agcod/request'
require 'aws_agcod/available_funds'

module AGCOD
  class GetAvailableFunds
    extend Forwardable

    def initialize(httpable, partner_id)
      @response = Request.new(httpable, 'GetAvailableFunds',
        'partnerId' => partner_id,
      ).response
    end

    def available_funds
      @response.payload['availableFunds'].map { |payload| AGCOD::AvailableFunds.new(payload) }
    end

    def timestamp
      Time.parse(@response.payload['timestamp'])
    end

    def status
      @response.payload['status']
    end

    def success?
      @response.payload['status'] == 'SUCCESS'
    end
  end
end
