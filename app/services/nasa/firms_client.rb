# frozen_string_literal: true

module Nasa
  class RemoteServerError < StandardError; end

  class FirmsClient
    class << self
      def fetch(url, date: julian_date)
        Rails.logger.info('Nasa::FirmsClient#fetch - Started')

        response = firms_client.get do |req|
          req.url "#{url}#{date}.txt"
          req.headers['Authorization'] = "Bearer #{Rails.application.credentials[:nasa_api][:key]}"
        end

        if response.success?
          Rails.logger.info('Nasa::FirmsClient#fetch - Completed')
          response.body
        else
          Rails.logger.error("Nasa::FirmsClient#fetch - Failed: #{response.status} #{response.body} - #{url}#{julian_date}")
          raise RemoteServerError
        end
      end

      private

      def julian_date
        @julian_date ||= "#{Date.today.year}#{"%.3d" % Date.today.yday}".to_i
      end

      def firms_client
        @firms_client ||= Faraday.new(url: 'https://nrt4.modaps.eosdis.nasa.gov')
      end
    end
  end
end
