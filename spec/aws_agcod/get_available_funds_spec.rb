require 'spec_helper'
require 'aws_agcod/get_available_funds'

describe AGCOD::GetAvailableFunds do
  let(:partner_id) { 'Testa' }
  let(:currency) { AGCOD::CreateGiftCard::CURRENCIES.first }
  let(:response) { spy }
  let(:httpable) { HTTP }

  subject { described_class.new(httpable, partner_id) }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context '.new' do
    it 'makes create request' do
      expect(AGCOD::Request).to receive(:new) do |httpable, action, params|
        expect(httpable).to eq(HTTP)
        expect(action).to eq('GetAvailableFunds')
        expect(params['partnerId']).to eq(partner_id)
      end.and_return(response)
      subject
    end
  end

#   <GetAvailableFundsResponse>
#   <availableFunds>
#   <currencyCode>GBP</currencyCode>
#  <amount>10.0</amount>
#   </availableFunds>
#  <timestamp>20170915T200959Z</timestamp>
#   <status>SUCCESS</status>
# </GetAvailableFundsResponse>
#
# #<AGCOD::GetAvailableFunds:0x000000001d069948 @response=#<AGCOD::Response:0x000000001d0873d0 @payload={"availableFunds"=>{"amount"=>0.0, "currencyCode"=>"USD"}, "status"=>"SUCCESS", "timestamp"=>"20180323T233815Z"}, @status="SUCCESS">>

  shared_context 'request with response' do
    let(:timestamp) { '20180323T233815Z' }
    let(:status) { 'SUCCESS' }
    let(:currency_code) { 'USD' }
    let(:amount) { 0.0 }
    let(:payload) { { "availableFunds" => { "amount" => amount, "currencyCode" => currency_code }, "status" => status, "timestamp" => timestamp } }

    before do
      allow(AGCOD::Request).to receive(:new) { double(response: response) }
      allow(response).to receive(:available_funds) { available_funds }
      allow(response).to receive(:timestamp) { timestamp }
      allow(response).to receive(:status) { status }
    end
  end

  context '#status' do
    include_context 'request with response'

    it 'returns status' do
      expect(subject.status).to eq('SUCCESS')
    end
  end

  # context '#expiration_date' do
  #   include_context 'request with response'
  #
  #   it 'returns expiration_date' do
  #     expect(request.expiration_date).to eq(Time.parse expiration_date)
  #   end
  # end
  #
  # context '#gc_id' do
  #   include_context 'request with response'
  #
  #   it 'returns gc_id' do
  #     expect(request.gc_id).to eq(gc_id)
  #   end
  # end
  #
  # context '#request_id' do
  #   include_context 'request with response'
  #
  #   it 'returns creation request_id' do
  #     expect(request.request_id).to eq(creation_request_id)
  #   end
  # end
  #
  # context '#status' do
  #   include_context 'request with response'
  #
  #   it 'returns the response status' do
  #     expect(request.status).to eq(status)
  #   end
  # end
end
