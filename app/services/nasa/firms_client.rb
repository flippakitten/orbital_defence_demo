# frozen_string_literal: true

module Nasa
  class RemoteServerError < StandardError; end

  class FirmsClient
    class << self
      def fetch(url, date: julian_date, retry_count: 0)
        Rails.logger.info('Nasa::FirmsClient#fetch - Started')

        response = firms_client.get do |req|
          req.url "#{url}#{date}.txt"
          req.headers['Authorization'] = "Bearer #{Rails.application.credentials[:nasa_api][:key]}"
        end

        if response.success?
          Rails.logger.info('Nasa::FirmsClient#fetch - Completed')
          response.body
        else
          retry_count += 1

          if retry_count <= 3
            Rails.logger.error("Nasa::FirmsClient#fetch - Failed: retrying #{retry_count}")
            sleep 5
            fetch(url, retry_count: retry_count)
          elsif retry_count == 4
            retry_count += 1
            prev_date = julian_date - 1

            Rails.logger.error("Nasa::FirmsClient#fetch - Failed: Fetching Last File #{url}#{prev_date}")
            fetch(url, date: prev_date, retry_count: retry_count)
          else
            retry_count = nil
            Rails.logger.error("Nasa::FirmsClient#fetch - Failed: #{response.status} #{response.body} - #{url}#{julian_date}")
            raise RemoteServerError
          end
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
