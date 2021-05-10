require 'rails_helper'

describe TrackDeliveryWorker do
  describe '#perform' do
    subject(:perform) { described_class.new.perform(carrier, tracking_number) }

    let(:carrier) { 'FEDEX' }
    let(:tracking_number) { Faker::Number.number.to_s }
    let(:delivery) { create(:delivery) }

    let(:mock_fedex_service) do
      allow(FedexService).to receive(:track_delivery).and_return(delivery)
    end

    let(:mock_kafka_sercive) do
      allow(KafkaClient).to receive(:produce_message)
    end

    before do
      mock_fedex_service
      mock_kafka_sercive
      perform
    end

    it 'calls fedex service' do
      expect(FedexService).to have_received(:track_delivery).with(tracking_number)
    end

    it 'queues a message in kafka' do
      topic = Rails.application.credentials.kafka[:topics][:deliveries]
      expect(KafkaClient).to have_received(:produce_message).with(delivery.to_json, topic: topic)
    end
  end
end
