class KafkaClient
  class << self
    def produce_message(data, topic:)
      producer = client.producer
      producer.produce(data, topic: topic)
      producer.deliver_messages
    end

    private

    def client
      @client ||= Kafka.new(Rails.application.credentials.kafka[:URL])
    end
  end
end
