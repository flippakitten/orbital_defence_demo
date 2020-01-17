class WeatherImportWorker
  include Sidekiq::Worker

  def perform
    Fire.where(detected_at: (Time.now - 24.hours)..Time.now).each do |fire|
      ImportOpenweatherData.new(fire).fetch_reading_and_create_station_data
    end
  end
end
