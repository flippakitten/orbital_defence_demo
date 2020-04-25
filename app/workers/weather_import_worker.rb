class WeatherImportWorker
  include Sidekiq::Worker

  def perform
    return if Rails.cache.read('WeatherImportWorker')

    Rails.cache.write('WeatherImportWorker', true, expires_in: 2.hour)

    Fire.in_last_24_hours.each do |fire|
      FireWeatherData.new(fire).find_or_create_weather
    end

    Rails.cache.write('WeatherImportWorker', false)
  end
end
