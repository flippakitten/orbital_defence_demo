class WeatherImportWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_executed, unique_across_queues: true, on_conflict: :reject

  def perform
    Fire.in_last_24_hours.each do |fire|
      FireWeatherData.new(fire).find_or_create_weather
    end
  end
end
