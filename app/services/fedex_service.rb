class FedexService < Fedex::Shipment
  def initialize
    fedex_credentials = Rails.application.credentials.fedex
    super(
      key: fedex_credentials[:key],
      password: fedex_credentials[:password],
      account_number: fedex_credentials[:account_number],
      meter: fedex_credentials[:meter],
      mode: fedex_credentials[:mode]
    )
  end
end
