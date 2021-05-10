class FedexService
  class << self
    include FedexHomologator

    def track_delivery(tracking_number)
      fedex_delivery = client.track(tracking_number: tracking_number)
      homologate_and_update_delivery(fedex_delivery.first)
    rescue Fedex::RateError
      raise NotFound
    end

    private

    def homologate_and_update_delivery(fedex_delivery)
      delivery = find_or_initialize_delivery(fedex_delivery.tracking_number)
      delivery.assign_attributes(
        status: status(fedex_delivery), package_weigth_unit: weight_unit(fedex_delivery),
        package_weigth: weight(fedex_delivery),
        package_dimensions_unit: dimension_unit(fedex_delivery),
        package_length: length(fedex_delivery), package_width: width(fedex_delivery),
        package_heigth: heigth(fedex_delivery)
      )
      delivery.save
      delivery
    end

    def find_or_initialize_delivery(tracking_number)
      Delivery.find_or_initialize_by(tracking_number: tracking_number, carrier: :FEDEX)
    end

    def client
      @client ||= Fedex::Shipment.new(
        key: fedex_credentials[:key],
        password: fedex_credentials[:password],
        account_number: fedex_credentials[:account_number],
        meter: fedex_credentials[:meter],
        mode: fedex_credentials[:mode]
      )
    end

    def fedex_credentials
      @fedex_credentials ||= Rails.application.credentials.fedex
    end
  end
end
