require 'rails_helper'

describe FedexService do
  describe '#track_delivery' do
    subject(:track_delivery) { described_class.track_delivery(tracking_number) }

    let(:tracking_number) { tracking_details[:tracking_number] }

    let(:tracking_information) { Fedex::TrackingInformation.new tracking_details }

    let(:tracking_details) do
      JSON.parse(File.read('./spec/fixtures/fedex-tracking-information.json'),
                 symbolize_names: true)
    end

    let(:mock_tracking) do
      allow_any_instance_of(Fedex::Shipment).to receive(:track).and_return([tracking_information])
    end

    before { mock_tracking }

    it 'returns a Delivery' do
      expect(track_delivery).to be_a Delivery
    end

    it 'homologates the status correctly' do
      expect(track_delivery.status.to_sym).to eq(:on_transit)
    end

    describe 'when the delivery was not tracked before' do
      it 'creates a new delivery instance' do
        expect { track_delivery }.to change(Delivery, :count).by(1)
      end
    end

    describe 'when the delivery was tracked before' do
      let(:delivery) do
        create(:delivery, tracking_number: tracking_number, carrier: :FEDEX, status: :created)
      end

      before do
        delivery
        track_delivery
      end

      it 'updates the delivery' do
        expect(delivery.reload.status.to_sym).to eq(:on_transit)
      end
    end

    describe 'when it does not find the delivery' do
      let(:mock_tracking) do
        allow_any_instance_of(Fedex::Shipment).to receive(:track).and_raise(Fedex::RateError)
      end

      it 'raises an error' do
        expect { track_delivery }.to raise_error(NotFound)
      end
    end
  end
end
