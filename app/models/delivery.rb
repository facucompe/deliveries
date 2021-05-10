class Delivery < ApplicationRecord
  validates :tracking_number, :status, :carrier, presence: true

  validates :tracking_number, uniqueness: { scope: :carrier }

  validates :package_weigth, :package_length,
            :package_width, :package_heigth, numericality: { grater_than: 0 }

  enum status: { created: 1, on_transit: 2, delivered: 3, exception: 4 }
  enum carrier: { fedex: 1, ups: 2 }
  enum package_weigth_unit: { kg: 1, lb: 2 }
  enum package_dimensions_unit: { cm: 1, in: 2 }
end
