require 'spec_helper'
require 'aws_agcod/get_available_funds'
require 'ostruct'

describe AGCOD::GetAvailableFunds do
  let(:partner_id) { 'Testa' }
  let(:currency) { AGCOD::CreateGiftCard::CURRENCIES.first }
  let(:httpable) { HTTP }
  let(:timestamp) { '20180323T233815Z' }
  let(:status) { 'SUCCESS' }
  let(:currency_code) { 'USD' }
  let(:amount) { 0.0 }
  OpenStruct.new(
    first_name: OpenStruct.new({
      primary: OpenStruct.new({
        first_name: 'Albus',
      }),
    }),
  )
  let(:payload) { { 'availableFunds' => { 'amount' => amount, 'currencyCode' => currency_code }, 'status' => status, 'timestamp' => timestamp } }

  let(:request_response) {
    OpenStruct.new(response:
      OpenStruct.new(payload:
        {
          'availableFunds' => [
            {
              'amount' => amount,
              'currencyCode' => currency_code
            }
          ],
          'status' => status,
          'timestamp' => timestamp
        }
      )
    )
  }

  subject { described_class.new(httpable, partner_id) }

  before do
    AGCOD.configure do |config|
      config.partner_id = partner_id
    end
  end

  context '.new' do
    it 'makes request' do
      expect(AGCOD::Request).to receive(:new) do |httpable, action, params|
        expect(httpable).to eq(HTTP)
        expect(action).to eq('GetAvailableFunds')
        expect(params['partnerId']).to eq(partner_id)
      end.and_return(request_response)

      expect(subject.available_funds.first.currency_code).to eq currency
      expect(subject.available_funds.first.amount).to eq amount
      expect(subject.timestamp).to eq Time.parse(timestamp)
      expect(subject.status).to eq status
      expect(subject.success?).to eq true
    end
  end
end
