module Kafka
  class DeliveryTrackingResponse
    attr_accessor :carrier, :tracking_number, :status, :delivery

    def initialize(carrier, tracking_number, status: nil, delivery: nil)
      @tracking_number = tracking_number
      @carrier = carrier
      @status = status
      @delivery = delivery
    end
  end
end
