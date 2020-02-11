# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'vcr', 'cassettes')
  config.hook_into :faraday
  config.configure_rspec_metadata!
end
