require 'rails_helper'

describe Api::V1::DeliveriesController do
  describe '#index' do
    subject(:make_request) { post :track, params: params }

    let(:params) { { delivery: { tracking_number: tracking_number, carrier: carrier } } }

    let(:tracking_number) { Faker::Number.number.to_s }

    let(:carrier) { 'FEDEX' }

    it 'returns accepted status' do
      make_request
      expect(response).to have_http_status :accepted
    end

    it 'enqueues a tracking worker' do
      expect { make_request }.to change { TrackDeliveryWorker.jobs.size }.by(1)
    end
  end
end
