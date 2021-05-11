class TrackDeliveryWorker
  include Sidekiq::Worker

  def perform(carrier, tracking_number)
    delivery = carrier_service(carrier).track_delivery(tracking_number)
    response = Kafka::DeliveryTrackingResponse.new(carrier, tracking_number,
                                                   status: :OK, delivery: delivery)
    send_kafka_response(response)
  rescue NotFound => e
    response = Kafka::DeliveryTrackingResponse.new(carrier, tracking_number, status: e.status)
    send_kafka_response(response)
  rescue ServiceError
    self.class.perform_in(2.minutes, carrier, tracking_number)
  end

  private

  def carrier_service(carrier)
    Carrier::SERVICES[carrier.to_sym]
  end

  def send_kafka_response(response)
    KafkaClient.produce_message(response.to_json, topic: deliveries_topic)
  end

  def deliveries_topic
    Rails.application.credentials.kafka[:topics][:deliveries]
  end
end
