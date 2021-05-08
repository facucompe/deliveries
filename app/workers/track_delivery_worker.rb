class TrackDeliveryWorker
  include Sidekiq::Worker

  def perform(*args)
    puts 'Tracking record...'
  end
end
