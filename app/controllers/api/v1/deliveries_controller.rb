module Api
  module V1
    class DeliveriesController < ApplicationController
      def track
        TrackDeliveryWorker.perform_async(delivery_params)
        head :accepted
      end

      private

      def delivery_params
        params.require(:delivery).permit(:tracking_number, :carrier)
      end
    end
  end
end
