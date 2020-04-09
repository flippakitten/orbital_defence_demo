class FirmsImportWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical

  def perform
    return if Rails.cache.read('FirmsImportWorkerRunning')

    Rails.cache.write('FirmsImportWorkerRunning', true, expires_in: 1.hour)

    Nasa::FirmsImport.all
    Rails.cache.write('fires-in_last_24_hours', Fire.in_last_24_hours, expires_in: 2.hours)
    Rails.cache.write('FirmsImportWorkerRunning', false)
  end
end
