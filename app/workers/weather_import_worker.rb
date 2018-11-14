class WeatherImportWorker
  include Sidekiq::Worker

  def perform
    ImportOpenweatherData.new.import
  end
end
