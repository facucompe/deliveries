require 'rails_helper'

describe Delivery do
  context 'when creating a delivery' do
    subject(:delivery) { build(:delivery) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:tracking_number) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:carrier) }
  end
end
