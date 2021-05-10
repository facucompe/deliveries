FactoryBot.define do
  factory :delivery do
    tracking_number         { Faker::Number.number.to_s }
    status                  { Delivery.statuses.keys.sample }
    carrier                 { Delivery.carriers.keys.sample }
    package_weigth_unit     { Delivery.package_weigth_units.keys.sample }
    package_weigth          { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    package_dimensions_unit { Delivery.package_dimensions_units.keys.sample }
    package_length          { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    package_width           { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    package_heigth          { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end
end
