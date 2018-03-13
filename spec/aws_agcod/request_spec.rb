require "spec_helper"
require "aws_agcod/request"

describe AGCOD::Request do
  let(:action) { "Foo" }
  let(:params) { {} }
  let(:signature) { double("Signature") }
  let(:signed_headers) { double("signed_headers") }
  let(:base_uri) { "https://example.com" }
  let(:partner_id) { "BAR" }
  let(:config) { double(uri: base_uri, partner_id: partner_id) }
  let(:httpable) { HTTP }

  context "#new" do
    before do
      allow(AGCOD).to receive(:config) { config }
      allow(AGCOD::Signature).to receive(:new).with(config) { signature }
    end

    context "with creationRequestId as special testing value" do
      let(:params) { { creationRequestId: creationRequestId } }

      subject { AGCOD::Request.new(httpable, action, params) }

      before do
        allow(signature).to receive(:sign).and_return(signed_headers)
      end

      context "with special creationRequestId F0000" do
        let(:creationRequestId) { "F0000" }

        it "does not add partnerId to creationRequestId" do
          expect(HTTP).to receive(:post) do |_, options|
            expect(JSON.parse(options[:body])["creationRequestId"]).to eq("F0000")
          end.and_return(double(body: params.to_json))
          subject
        end
      end

      context "with special creationRequestId F2005" do
        let(:creationRequestId) { "F2005" }

        it "does not add partnerId to creationRequestId" do
          expect(HTTP).to receive(:post) do |_, options|
            expect(JSON.parse(options[:body])["creationRequestId"]).to eq("F2005")
          end.and_return(double(body: params.to_json))
          subject
        end
      end
    end

    it "sends post request to endpoint uri" do
      expect(signature).to receive(:sign) do |uri, headers, body|
        expect(uri).to eq(URI("#{base_uri}/#{action}"))
        expect(headers.keys).to match_array(%w(content-type x-amz-date accept host x-amz-target date))
        expect(headers["content-type"]).to eq("application/json")
        expect(headers["x-amz-target"]).to eq("com.amazonaws.agcod.AGCODService.#{action}")
        expect(JSON.parse(body)["partnerId"]).to eq(partner_id)
      end.and_return(signed_headers)

      expect(HTTP).to receive(:post) do |uri, options|
        expect(uri).to eq(URI("#{base_uri}/#{action}"))
        expect(JSON.parse(options[:body])["partnerId"]).to eq(partner_id)
        expect(options[:headers]).to eq(signed_headers)
      end.and_return(double(body: params.to_json))

      AGCOD::Request.new(httpable, action, params)
    end

    it "sets response" do
      expect(signature).to receive(:sign) { signed_headers }
      expect(HTTP).to receive(:post) { (double(body: params.to_json)) }

      response = AGCOD::Request.new(httpable, action, params).response

      expect(response).to be_a(AGCOD::Response)
    end
  end
end
