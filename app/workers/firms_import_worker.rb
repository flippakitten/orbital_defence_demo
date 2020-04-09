class FirmsImportWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed, unique_across_queues: true, on_conflict: :reject

  def perform
    Nasa::FirmsImport.all
    Rails.cache.write('fires-in_last_24_hours', Fire.in_last_24_hours, expires_in: 2.hours)
  end
end
