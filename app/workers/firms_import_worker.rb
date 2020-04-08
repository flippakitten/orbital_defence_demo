class FirmsImportWorker
  include Sidekiq::Worker

  def perform
    Nasa::FirmsImport.all
    Rails.cache.write('fires-in_last_24_hours', Fire.in_last_24_hours)
  end
end
