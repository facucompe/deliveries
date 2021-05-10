class TrackDeliveryWorker
  include Sidekiq::Worker

  def perform(carrier, tracking_number)
    delivery = carrier_service(carrier).track_delivery(tracking_number)
    KafkaClient.produce_message(delivery.to_json, topic: deliveries_topic)
  end

  private

  CARRIER_SERVICES = {
    FEDEX: FedexService
    # UPS: UPSService
  }.freeze

  def carrier_service(carrier)
    CARRIER_SERVICES[carrier.to_sym]
  end

  def deliveries_topic
    Rails.application.credentials.kafka[:topics][:deliveries]
  end
end
