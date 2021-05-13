module FedexHomologator
  STATUSES = {
    DE: :exception,
    SE: :exception,
    CA: :exception,
    CD: :created,
    HL: :created,
    OC: :on_transit,
    AP: :on_transit,
    DL: :delivered
  }.freeze

  WEIGHT_UNITS = {
    LB: :lb,
    KG: :kg
  }.freeze

  DIMENSION_UNITS = {
    IN: :in,
    CM: :cm
  }.freeze

  def status(delivery)
    STATUSES[delivery.status_code.to_sym]
  end

  def weight_unit(delivery)
    WEIGHT_UNITS[delivery.details.dig(:package_weight, :units).to_sym]
  end

  def weight(delivery)
    delivery.details[:package_weight][:value].to_f
  end

  def dimension_unit(delivery)
    DIMENSION_UNITS[delivery.details.dig(:package_dimensions, :units).to_sym]
  end

  def length(delivery)
    delivery.details.dig(:package_dimensions, :length).to_f
  end

  def width(delivery)
    delivery.details.dig(:package_dimensions, :width).to_f
  end

  def heigth(delivery)
    delivery.details.dig(:package_dimensions, :height).to_f
  end
end
