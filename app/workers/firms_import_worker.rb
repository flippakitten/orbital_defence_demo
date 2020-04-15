class FirmsImportWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical

  def perform
    Nasa::FirmsImport.all
  end
end
