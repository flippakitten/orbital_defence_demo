class FirmsImportWorker
  include Sidekiq::Worker

  def perform
    ImportFirmsData.import
    ActiveFire.new.create_fires_with_readings
  end
end
