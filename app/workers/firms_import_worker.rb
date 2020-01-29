class FirmsImportWorker
  include Sidekiq::Worker

  def perform
    Nasa::FirmsImport.all
  end
end
