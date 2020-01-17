class FirmsImportWorker
  include Sidekiq::Worker

  def perform
    ImportFirmsData.import
  end
end
