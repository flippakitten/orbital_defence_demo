# frozen_string_literal: true

module Nasa
  class FirmsImport
    require 'csv'

    FIRMS_DATA_URLS = {
        # modis: '/api/v2/content/archives/FIRMS/c6/Australia_NewZealand/MODIS_C6_Australia_NewZealand_MCD14DL_NRT_',
        # virrs: '/api/v2/content/archives/FIRMS/viirs/Australia_NewZealand/VIIRS_I_Australia_NewZealand_VNP14IMGTDL_NRT_'
        modis: '/api/v2/content/archives/FIRMS/c6/Global/MODIS_C6_Global_MCD14DL_NRT_',
        virrs: '/api/v2/content/archives/FIRMS/viirs/Global/VIIRS_I_Global_VNP14IMGTDL_NRT_'
        #modis: '/api/v2/content/archives/FIRMS/c6/Southern_Africa/MODIS_C6_Southern_Africa_MCD14DL_NRT_',
        #viirs: '/api/v2/content/archives/FIRMS/viirs/Southern_Africa/VIIRS_I_Southern_Africa_VNP14IMGTDL_NRT_'
    }

    class << self
      def all
        FIRMS_DATA_URLS.each do |key, url|
          csv_text = Nasa::FirmsClient.fetch(url)

          parse_and_create_fire(csv_text: csv_text, scan_type: key)

        rescue Nasa::RemoteServerError
          Rails.logger.error("Nasa::FirmsImport#all - Failed to fetch #{key}")
        end
      end

      def file(file:, scan_type:)
        parse_and_create(
          csv_text: File.read(Rails.root.join('external_data', file)),
          scan_type: scan_type
        )
      end

      private

      def parse_and_create_fire(csv_text:, scan_type:)
        CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1').each do |row|
          Fire.create_from_csv_row(row, scan_type)
        end
      end
    end
  end
end