require 'rails_helper'

describe TrackDeliveryWorker do
  describe '#perform' do
    subject(:perform) { described_class.new.perform(carrier, tracking_number) }

    let(:carrier) { 'FEDEX' }
    let(:tracking_number) { Faker::Number.number.to_s }
    let(:delivery) { create(:delivery) }

    let(:mock_kafka_sercive) do
      allow(KafkaClient).to receive(:produce_message)
    end

    let(:topic) { Rails.application.credentials.kafka[:topics][:deliveries] }

    before do
      mock_fedex_service
      mock_kafka_sercive
      perform
    end

    describe 'when it finds the delivery successfully' do
      let(:mock_fedex_service) do
        allow(FedexService).to receive(:track_delivery).and_return(delivery)
      end

      it 'calls fedex service' do
        expect(FedexService).to have_received(:track_delivery).with(tracking_number)
      end

      it 'queues a message in kafka' do
        response = Kafka::DeliveryTrackingResponse.new(carrier, tracking_number,
                                                       status: :OK, delivery: delivery)
        expect(KafkaClient).to have_received(:produce_message).with(response.to_json, topic: topic)
      end
    end

    describe 'when the delivery does not exist' do
      let(:mock_fedex_service) do
        allow(FedexService).to receive(:track_delivery).and_raise(NotFound)
      end

      it 'queues a message in kafka with NOT_FOUND status' do
        response = Kafka::DeliveryTrackingResponse.new(carrier, tracking_number,
                                                       status: :NOT_FOUND)
        expect(KafkaClient).to have_received(:produce_message).with(response.to_json, topic: topic)
      end
    end

    describe 'when the carrier service fails' do
      let(:mock_fedex_service) do
        allow(FedexService).to receive(:track_delivery).and_raise(ServiceError)
      end

      it 'queues a message in kafka with NOT_FOUND status' do
        response = Kafka::DeliveryTrackingResponse.new(carrier, tracking_number,
                                                       status: :SERVICE_ERROR)
        expect(KafkaClient).to have_received(:produce_message).with(response.to_json, topic: topic)
      end
    end
  end
end
